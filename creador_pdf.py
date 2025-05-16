
import os
from flask import Flask, render_template, request,Blueprint
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from Final.auth import login_required
from Final.class_metodo import ManejoFechas

bp = Blueprint('creador_pdf', __name__)


@bp.route('/pdf_coti_auto', methods = ['GET','POST'])
@login_required
def pdf_coti_auto():
    return render_template('todo/formularios_pdf/pdf_coti_auto.html')

@bp.route('/generar_pdf', methods = ['GET','POST'])
@login_required
def generar_pdf():
    manejo_fechas = ManejoFechas()
    if request.method == 'POST':
        nombre = request.form['nombre']
        edad = request.form['edad']
        email = request.form['email']

        fecha = manejo_fechas.fecha_hoy_DDMM()
        # Crear el archivo PDF con tamaño A4
        pdf_filename = f'C:/Users/Usuario/Desktop/basura/cotizaciones_pdf/coti_{nombre}_{fecha}.pdf'
        c = canvas.Canvas(pdf_filename, pagesize=A4)
        
        # Crear un párrafo con la información ingresada
        info_paragraph = f'Nombre: {nombre}\nEdad: {edad}\nEmail: {email}'
        c.drawString(50, 750, "Información del usuario:")
        c.drawString(50, 730, info_paragraph)
        c.save()

        return render_template('todo/formularios_pdf/pdf_coti_auto_final.html',nombre = nombre, edad = edad)
        # return f'Se ha generado el archivo PDF: <a href="{pdf_filename}" target="_blank">Descargar PDF</a>'
