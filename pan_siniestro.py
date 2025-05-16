from os import error

from flask import (
    Blueprint, redirect, url_for, flash, render_template, request)

from Final.auth import login_required
from Final.def_mod_pan_siniestro import Info_Panel_Siniestro


bp = Blueprint('pan_siniestro', __name__)


@bp.route('/pan_siniestro', methods = ['GET','POST'])
@login_required
def pan_siniestro():
    print ('lili')
    itinerador_ = Info_Panel_Siniestro()
    succes_tabla_panel_siniestro = itinerador_.def_panel_siniestro()
   
    print (succes_tabla_panel_siniestro)
    
    return  render_template ('todo/paneles/pan_siniestro.html')  
    pass