from tkinter import *
from tkinter.filedialog import askopenfilename
from tkinter.messagebox import showerror
from PIL import Image, ImageTk, ImageFilter, ImageOps

image = Image.new('RGB', (800,1280), (255, 255, 255)) #global image

class MyFrame(Frame):
    def __init__(self):
        Frame.__init__(self)
        self.master.title("ImageShop")
        self.master.rowconfigure(5, weight=1)
        self.master.columnconfigure(5, weight=1)
        self.master.minsize(width = 600, height = 500)
        self.grid()

        self.buttonLoad = Button(self, text="Open", # load img button
        command = self.load_img, width=10)
        self.buttonLoad.grid()

    def load_img(self):
        global image
        imgname = askopenfilename(filetypes=(("JPG files", "*.jpg"),
        ("PNG files", "*.png"),
        ("BMP files", "*.bmp")))

        if imgname:
            try:
                print(imgname)
                image = Image.open(imgname)
                tkimage = ImageTk.PhotoImage(image)
                Label(image = tkimage).grid(row = 0, column = 8,padx = 10, pady= 10)

                self.buttonHF = Button(self,text="flipH",
                command = self.H_flip,width=10)
                self.buttonHF.grid(row = 1, column = 0, padx = 10, pady = 1) # horizontal flip button

                self.buttonVF = Button(self,text="flipV",
                command = self.V_flip,width=10)
                self.buttonVF.grid(row = 2, column = 0, padx = 10, pady = 1) # vertical flip button

                self.buttonGS = Button(self,text="GrayScale",
                command = self.GSFilter,width=10)
                self.buttonGS.grid(row = 3, column = 0, padx = 10, pady = 1) # GS filter

                self.LblQT = Label(self, text = "QT number:") # label qt
                self.LblQT.grid(row = 4, column = 0, padx = 1, pady =1)

                self.EQT = Entry(self, bd =3, width = 10) # Image quantization
                self.EQT.bind("<Return>",lambda numqt: self.QTFilter(numqt = self.EQT.get()))
                self.EQT.grid(row = 4, column = 1)

                self.buttonQT = Button(self, text="Ok",
                command = lambda: self.QTFilter(numqt = self.EQT.get()), width=5)
                self.buttonQT.grid(row = 4, column = 2, ) # Image qt button


                self.LblSV = Label(self, text = "Save as:") # label qt
                self.LblSV.grid(row = 5, column = 0)

                self.ESV = Entry(self, bd =3, width = 10) # Image quantization
                self.ESV.bind("<Return>",lambda name: self.save_img(name = self.ESV.get()))
                self.ESV.grid(row = 5, column = 1)

                self.buttonSV = Button(self, text="Save",
                command = lambda: self.save_img(name = self.ESV.get()),width=5)
                self.buttonSV.grid(row = 5, column = 2)

                mainloop()
            except:
                showerror("Open Source File", "Failed to read image\n '%s'" %imgname)
            return

    def H_flip(self): # horizontal flip with pixel by pixel operations
        global image
        width = image.size[0]
        height = image.size[1]
        for y in range(height):
            for x in range(width // 2):
                left = image.getpixel((x, y))
                right = image.getpixel((width - 1 - x, y))
                image.putpixel((width - 1 - x, y), left)
                image.putpixel((x, y), right)

        HFimg = ImageTk.PhotoImage(image)
        Label(image = HFimg).grid(row = 0, column = 20)
        mainloop()
        return HFimg

    def V_flip(self):
        global image
        width = image.size[0]
        height = image.size[1]

        for y in range(height // 2):
            for x in range(width):
                left = image.getpixel((x, y))
                right = image.getpixel((x , height - y - 1))
                image.putpixel((x, height - y -1), left)
                image.putpixel((x, y), right)

        VFimg = ImageTk.PhotoImage(image)
        Label(image = VFimg).grid(row = 0, column = 20)
        mainloop()
        return VFimg

    def save_img(self, name):
        global image
        image.save(name) # Salvando a imagem

    # Create a new image with the given size
    def create_image(self, i, j):
        image = Image.new("RGB", (i, j), "white")
        return image

    def set_pixel(self, image, i, j):
        # image bounds
        width, height = image.size
        if i > width or j > height:
            return None

        pixel = image.setpixel((i, j))
        return pixel

    def get_pixel(self, image, i, j):
        # image bounds
        width, height = image.size
        if i > width or j > height:
            return None

        # get pixel
        pixel = image.getpixel((i, j))
        return pixel

    # Create a Grayscale version of the image
    def GSFilter(self):
        global image
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
        Label(image = GSimg).grid(row = 0, column = 20)

        image = new

        mainloop()

        return new

    def QTFilter(self, numqt):
        global image
        width, height = image.size
        newimg = self.create_image(width, height)
        newpixels = newimg.load()

        num = int(numqt)

        if num > 256:
            num = 256;
        elif num <= 0:
            num = 1;

        prop = 256 / num

        for i in range(width):
            for j in range(height):
                pixel = self.get_pixel(image, i, j)

                Red = pixel[0]
                Green = pixel[1]
                Blue = pixel[2]

                Rchan = Red / prop
                Gchan = Green / prop
                Bchan = Blue / prop

                newR = Rchan * prop + (prop / 2)
                newG = Gchan * prop + (prop / 2)
                newB = Bchan * prop + (prop / 2)

                if newR > 255:
                    newR = 255;
                if newG > 255:
                    newG = 255;
                if newB > 255:
                    newB = 255;

                newpixels[i, j] = (int(newR), int(newG), int(newB))

        #new = image.quantize(int(num), None, 0, None)
        QTimg = ImageTk.PhotoImage(newimg)
        Label(image = QTimg).grid(row = 0, column = 20)

        image = newimg

        mainloop()

        return newimg

if __name__=="__main__":
    MyFrame().mainloop()
