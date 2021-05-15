#!/usr/bin/python3

import tkinter as tk
import tkinter.font as tkFont
import subprocess as sub
from tkinter import ttk
import threading
import queue
import time
import sys
import os
import signal

class Root:
	def __init__(self, master):
		self.master = master
		self.initgui(master)

	def initgui(self, master):
		self.master = master
		self.MainFrame = tk.Frame(self.master)
		self.MainFrame.grid(row=0, column=0)
		self.LowerFrame = tk.Frame(self.master, height=30, width=25)
		self.LowerFrame.grid(row=1, column=0)
		##self.ShutDownFrame= tk.Frame(self.master)
		self.run_button = tk.Button(self.MainFrame, text='RUN', font=('Helvetica', '16'), command=self.btnPressed, height=1, width=10)
		self.run_button.grid(row=1, column=0)
		self.reset_button = tk.Button(self.MainFrame, text='RESET',font=('Helvetica', '16'), command=self.reset, height=1, width=5)
		self.reset_button.grid(row=1, column=1)
		##self.shutdown_button = tk.Button(self.MainFrame, text='SHUTDOWN', font=('Helvetica','16'), command=self.askShutDown, height=1, width=5)
		##self.shutdown_button.grid(row=0, column=0)
		self.font = tkFont.Font(size=14)
		self.txt = tk.Text(self.LowerFrame, wrap='word', height=19, width=25, font=self.font)

	def reset(self):
		pid = os.getpid()
		pgid = os.getpgid(pid)
		s = "/home/pi/LLDPi/reset.sh %s"%(pgid)
		sub.call(s, shell=True)

	def progress(self, master):
		self.prog_bar = ttk.Progressbar(
		self.LowerFrame, orient="horizontal",
		length=100, mode="determinate")
		self.prog_bar.grid(row=0, column=0)

	def btnPressed(self):
		self.run_button.configure(state='disabled', text='RUNNING')
##		self.shutdown_button.configure(state='disabled')
		self.progress(self.master)
		self.master.update()
		self.queue = queue.Queue()
		ThreadedTask(self.queue).start()
		self.master.after(100, self.process_queue)

	def process_queue(self):
		try:
			msg = self.queue.get(0)
			self.prog_bar.stop()
			self.prog_bar.destroy()
			self.run_button.configure(state='normal', text='RUN')
			##self.shutdown_button.configure(state='normal')
		except queue.Empty:
			file = open('/home/pi/LLDPi/progress','r')
			self.prog_bar["value"] = int(file.read())
			self.master.after(100, self.process_queue)

	def displayInfo(self):
		self.txt.delete('1.0', 'end')
		filename = '/home/pi/LLDPi/displayLLDP.txt'
		with open(filename, 'r') as f:
			self.txt.insert('insert', f.read())
		self.txt.grid(row=1, column=0, sticky='W')
		scrollb = tk.Scrollbar(self.LowerFrame, width=14, command=self.txt.yview)
		scrollb.grid(row=1, column=1, sticky='NSW')
		self.txt['yscrollcommand'] = scrollb.set

##	def askShutDown(self):
##		self.MainFrame.grid_remove()
##		self.LowerFrame.grid_remove()
##		self.ShutDownFrame.grid(row=0, column=0)
##		labelFont = ('Helvetica', 15, 'bold')
##		Lbl = tk.Label(self.ShutDownFrame, text="Would you like to shutdown device?", wraplength='400')
##		Lbl.config(height=8, width=26, font=labelFont)
##		Lbl.grid(row=0, column=0, columnspan=2)
##		B1 = tk.Button(self.ShutDownFrame, text='YES', font=('Helvetica', '10', 'bold'), width=14, height=6, command=self.shutDown)
##		B1.grid(row=1, column=0)
##		B2 = tk.Button(self.ShutDownFrame, text='NO', font=('Helvetica', '10', 'bold'),  width=14, height=6, command=self.backToMain)
##		B2.grid(row=1, column=1)
##
##	def shutDown(self):
##		sub.call('sudo shutdown -h now', shell=True)
##
	def backToMain(self):
##		self.ShutDownFrame.grid_remove()
		self.MainFrame.grid()
		self.LowerFrame.grid()

class ThreadedTask(threading.Thread):
	def __init__(self, queue):
		threading.Thread.__init__(self)
		self.queue = queue
	def run(self):
		sub.call('source /home/pi/LLDPi/lldp.sh', shell=True, executable='/bin/bash')
		main_ui.displayInfo()
		self.queue.put("Task finished")

if __name__ == "__main__":
	root = tk.Tk()
	root.title("LLDPi")
	root.attributes('-fullscreen', True)
	main_ui = Root(root)
	main_ui.btnPressed()
	root.mainloop()

