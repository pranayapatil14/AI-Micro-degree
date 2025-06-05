import tkinter as tk
from tkinter import messagebox
import random
import string

def generate_password(length=12):
    characters = string.ascii_letters + string.digits + string.punctuation
    password = ''.join(random.choice(characters) for i in range(length))
    return password

def display_password():
    password = generate_password()
    password_var.set(password)  

def copy_to_clipboard():
    root.clipboard_clear()  
    root.clipboard_append(password_var.get())  
    messagebox.showinfo("Copied", "Password copied to clipboard!")

root = tk.Tk()
root.title("Password Generator")
root.geometry("400x300")  

password_var = tk.StringVar()

title_label = tk.Label(root, text="Password Generator", font=("Helvetica", 16))
title_label.pack(pady=20)

password_label = tk.Label(root, textvariable=password_var, font=("Helvetica", 14), bg="lightgray", width=30)
password_label.pack(pady=10)

generate_button = tk.Button(root, text="Generate Password", font=("Helvetica", 12), command=display_password)
generate_button.pack(pady=10)

copy_button = tk.Button(root, text="Copy to Clipboard", font=("Helvetica", 12), command=copy_to_clipboard)
copy_button.pack(pady=10)

root.mainloop()
