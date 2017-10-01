from tkinter import *
from tkinter.filedialog import askopenfilename
from tkinter.messagebox import showerror
from PIL import Image, ImageTk

class MyFrame(Frame):
    def __init__(self):
        Frame.__init__(self)
        self.master.title("Image editor")
        self.master.rowconfigure(5, weight=1)
        self.master.columnconfigure(5, weight=1)
        self.master.minsize(width = 500, height = 500)
        #self.grid(padx=250, pady=250,sticky=W+E+N+S)
        self.pack()

        self.button = Button(self, text="Open",
        command = self.load_img, width=10)
        #self.button.grid(row=0, column=0,sticky=W+E+N+S)
        self.button.pack()

    def load_img(self):
        imgname = askopenfilename(filetypes=(("JPG files", "*.jpg"),
        ("PNG files", "*.png"),
        ("BMP files", "*.bmp")))

        if imgname:
            try:
                print(imgname)
                image = Image.open(imgname)
                tkimage = ImageTk.PhotoImage(image)
                Label(image = tkimage).pack(side=LEFT)
                mainloop()
            except:
                showerror("Open Source File", "Failed to read image\n '%s'" %imgname)
            return

if __name__=="__main__":
    MyFrame().mainloop()
