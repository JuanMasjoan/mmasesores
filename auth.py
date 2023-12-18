import functools

from flask import (
    Blueprint, flash, g, render_template, request, url_for, session, redirect
)

from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import redirect
from Final.class_metodo import Insert_tabla, ManejoFechas
from Final.db import get_db
from Final import db

bp = Blueprint('auth', __name__, url_prefix='/auth')

@bp.route('/register', methods=['GET','POST'])
def register():
    if request.method == 'POST':
        username = request.form ['username']
        password = request.form ['password']
        db , c = get_db()
        error = None
        c.execute(
            'select id from user where username = %s', (username,)
        )
        if not username:
            error = 'USUARIO ES NECESARIO'
        if not password:
            error = 'constraseña es nesecario'
        elif c.fetchone() is not None:
            error = 'el usuario  {} ya se encuentra registrado' .format(username)
        
        if error is None:
            c.execute(
                'insert into user (username, password) values (%s, %s)',
                (username, generate_password_hash(password))
            )
            db.commit()
            return redirect(url_for('auth.login'))
        flash(error)
    
    return render_template('auth/register.html')

@bp.route ('/login/', methods = ['GET','POST'])
def login ():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        db , c = get_db()
        error = None
        c.execute(
            'select * from user where username = %s', (username,)
        )
        user = c.fetchone()

        if user is None:
            error = 'usuario y/o contraseña incorrecta'
        elif not check_password_hash(user['password'], password):
            error = 'usuario y/o contraseña incorrecta'
        
        if error is None:
            session.clear()
            session['user_id'] = user['id']
            
            upd_diario = Insert_tabla()
            fechas = ManejoFechas()

            fecha_vencer = fechas.fechas_30_dias()
            fecha_pago_efect = fechas.fechas_15_dias()
            fecha_hoy = fechas.fecha_2actual()
            #sp_name_ult_upd = 'sp_dias_ult_upd'
            #valores_buscar123 = (1,)
            #success, fecha_ult_upd = upd_diario.select_sp(sp_name_ult_upd, *valores_buscar123)


            #print(fecha_ult_upd[1])

            valores_buscar = (str(fecha_vencer), str(fecha_pago_efect),str(fecha_hoy))
            success, upd_diario_resultado = upd_diario.select_sp('sp_upd_diarias', valores_buscar)    
            
            if 'mensaje' in upd_diario_resultado[0]:
                flash(upd_diario_resultado[0]['mensaje'])
            else:
                flash('Actualizacion realizada correctamente')
        
            return redirect(url_for('todo.index'))
        flash(error)
    return render_template ('auth/login.html')

@bp.before_app_request
def load_logged_in_user():
    user_id = session.get('user_id')

    if user_id is None:
        g.user = None
    else:
        db, c = get_db()
        c.execute(
            'select * from user where id = %s', (user_id,)
        )
        g.user = c.fetchone()

def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwards):
        if g.user is None:
            return redirect(url_for('auth.login'))
        
        return view(**kwards)
    return wrapped_view

@bp.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('auth.login'))