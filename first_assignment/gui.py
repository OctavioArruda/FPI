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

                self.buttonGS = Button(self,text="GrayScale",
                command = lambda: self.GSFilter(image),width=10)
                self.buttonGS.pack(side=LEFT, fill=BOTH, anchor = SW) # GS filter

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

    # Create a new image with the given size
    def create_image(self, i, j):
        image = Image.new("RGB", (i, j), "white")
        return image

    def get_pixel(self, image, i, j):
        # image bounds
        width, height = image.size
        if i > width or j > height:
            return None

        # get pixel
        pixel = image.getpixel((i, j))
        return pixel

    # Create a Grayscale version of the image
    def GSFilter(self, image):
        # Get size
        width, height = image.size

        # Create new Image and a Pixel Map
        new = self.create_image(width, height)
        pixels = new.load()

        # Transform to grayscale
        for i in range(width):
            for j in range(height):
                # Get Pixel
                pixel = self.get_pixel(image, i, j)

                # Get R, G, B values (This are int from 0 to 255)
                red =   pixel[0]
                green = pixel[1]
                blue =  pixel[2]

                # Transform to grayscale
                gray = (red * 0.299) + (green * 0.587) + (blue * 0.114)

                # Set Pixel in new image
                pixels[i, j] = (int(gray), int(gray), int(gray))


        # Show image
        GSimg = ImageTk.PhotoImage(new)
        Label(image = GSimg).pack(side=LEFT)
        mainloop()
        # Return new image
        return new

        #pix =   image.load()
        #print (image.size)
        #pixels = list(image.getdata()) #lista pixels

        #print("GrayScale Filter")
        #newimg = ImageOps.grayscale(image)
        #GSimg = ImageTk.PhotoImage(newimg)
        #Label(image = GSimg).pack(side=LEFT)
        mainloop()

if __name__=="__main__":
    MyFrame().mainloop()
