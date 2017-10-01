from tkinter import *
from tkinter.filedialog import askopenfilename
from tkinter.messagebox import showerror
from PIL import Image, ImageTk, ImageFilter, ImageOps

class MyFrame(Frame):
    def __init__(self):
        Frame.__init__(self)
        self.master.title("Image editor")
        self.master.rowconfigure(5, weight=1)
        self.master.columnconfigure(5, weight=1)
        self.master.minsize(width = 500, height = 500)
        self.pack()

        self.buttonLoad = Button(self, text="Open", # load img button
        command = self.load_img, width=10)
        self.buttonLoad.pack(side=LEFT)




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

                self.buttonHF = Button(self,text="flipH",
                command = lambda: self.H_flip(image),width=10)
                self.buttonHF.pack(side=LEFT, fill=BOTH, anchor = SW) # horizontal flip button

                self.buttonVF = Button(self,text="flipV",
                command = lambda: self.V_flip(image),width=10)
                self.buttonVF.pack(side=LEFT, fill=BOTH, anchor = SW) # vertical flip button

                mainloop()
            except:
                showerror("Open Source File", "Failed to read image\n '%s'" %imgname)
            return

    def H_flip(self, image):
        print(image.bits)
        newimg = ImageOps.flip(image)
        HFimg = ImageTk.PhotoImage(newimg)
        Label(image = HFimg).pack(side=LEFT)
        mainloop()

    def V_flip(self, image):
        print("lul")
        newimg = ImageOps.mirror(image)
        VFimg = ImageTk.PhotoImage(newimg)
        Label(image = VFimg).pack(side=LEFT)
        mainloop()

if __name__=="__main__":
    MyFrame().mainloop()
