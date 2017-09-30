from PIL import Image, ImageTk
import tkinter as tk

ler = input("Deseja ler alguma imagem?")

while(ler == "sim" or ler == "Sim" or ler == "SIM"):

    img_name = input("Nome da imagem por favor.")
    jpgfile = Image.open(img_name) # Abrindo a imagem

    janela = tk.Tk()
    tkimage = ImageTk.PhotoImage(jpgfile)
    lblImg = tk.Label(janela, image = tkimage).pack()
    LblText = tk.Label(text = str(jpgfile.bits) + str(jpgfile.size) + str(jpgfile.format)).pack()
    janela.mainloop()
    #print (jpgfile.bits, jpgfile.size, jpgfile.format)
    savedimg_name = input("Nome que deseja colocar na img para salvar.")
    jpgfile.save(savedimg_name) # Salvando a imagem
    ler = input("Deseja ler mais algum imagem?")
