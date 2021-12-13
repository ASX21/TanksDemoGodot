<h1>Demo de tanques de Godot</h1>
<p>Demostración creada como recurso de aprendizaje de Godot Engine. Código completamente abierto.</p><p><b>Usada la extensión para Godot de GitHub.</b></p>
<a href="https://godotengine.org/download">Descarga Godot aquí. Versión del proyecto: 3.4</a>
<h2>Introducción al sistema de nodos</h2>
<p>Godot emplea un sistema de jerarquía de nodos donde una escena puede ser cualquier rama de nodos. ¿Qué significa esto?</p>
<ol>
	<li>Los elementos que vas a usar en el juego son siempre nodos. Cada uno tiene su propio tipo.</li>
	<li>Los nodos se organizan en forma de árbol. Hay un nodo raíz del cuál se van desplegando en forma de árbol más nodos. <b>Todo nodo hijo tiene un nodo padre a no ser que sea el nodo raíz</b></li>
	<li>Las escenas son un pequeño árbol de nodos. Esto se usa para tener pequeños árboles de escenas que instanciar o eliminar por código. Por ejemplo, un enemigo podría ser una escena.</li>
</ol>
<p>Pongamos un ejemplo de un árbol similar a los nodos de Godot.</p>
<p>Tenemos la carpeta Escritorio. Este es el nodo raíz. En otra carpeta tenemos la carpeta "Tarea Marzo" con subcarpetas, esta podría ser en Godot una escena que instanciamos por código, resultando en "Tarea Marzo 1" y "Tarea Marzo 2".</p>
<ul>
<li>Escritorio
	<ul>
		<li>Tarea Marzo 1
			<ul>
				<li>ACDA</li>
				<li>PMDM</li>
			</ul>
		</li>
		<li>Tarea Marzo 2
			<ul>
				<li>ACDA</li>
				<li>PMDM</li>
			</ul>
		</li>
	</ul>
	</li>
</ul>
<hr>
<h2>Godot</h2>
<h3>Cargando el proyecto</h3>
<p>Nada más abrir todo, nos aparece la pantalla de carga de proyecto:</p>
<img src="https://github.com/ASX21/TanksDemoGodot/blob/main/ReadMeImages/ProjectSelection.png"/>
<p>¿No te aparecen tantos proyectos? No pasa nada, esos proyectos son parte de los que vienen con Godot al descargarlo desde Steam.</p>
<p>Para cargar el proyecto tras descargar el repositorio tienes dos opciones:</p>
<ul>
<li>Descomprimirlo, darle a importar y seleccionar el archivo .godot.</li>
<li>Importar el .zip y seleccionar una carpeta vacía en la que descomprimir el proyecto.</li>
</ul>
<p>En esta ventana también puedes descargarte proyectos de muestra o crear los tuyos propios.</p>
<hr>
<h3>La interfaz del editor</h3>
<p>Una vez cargado el proyecto, verás la interfaz del editor.</p>
<img src="https://github.com/ASX21/TanksDemoGodot/blob/main/ReadMeImages/GodotEditor.png"/>
<p>Esta es la interfaz que usaremos para hacer juegos. No tiene absolutamente todas las herramientas necesarias, pero sí las dedicadas a funcionalidad del juego. Es decir, no podemos diseñar a nuestros personajes ni el sonido del juego, aunque sí programar cómo se moverán y añadir efectos visuales con shaders y partículas.</p>
<p>Mirando la imagen, lo que más llama la atención es el panel con la escena actual. También, al seleccionar un script, se abrirá ahí el editor de texto integrado en Godot.</p>
<h4>El panel de escena</h4>
<p>Este panel situado a la izquierda muestra el árbol de nodos de la escena actual. Para poder ver todo más fácilmente podemos plegar o desplegar cualquier rama de nodos en la escena.</p><p>Con click derecho puedes agregar un nodo hijo al nodo seleccionado. Además, con un nodo seleccionado, puedes darle click izquierdo al botón de arriba a la derecha con un símbolo "+" de color verde para añadir un script. Si ya lo tiene, mostrará una "x" roja y lo quitará. Este es el panel:</p>
<img src="https://github.com/ASX21/TanksDemoGodot/blob/main/ReadMeImages/ScenePanel.png"/>
<h4>El panel de archivos</h4>
<p>Debajo del panel anterior se encuentra el de archivos. En este podemos navegar las carpetas del proyecto. Es recomendable organizar correctamente los archivos del juego para facilitar encontrarlos en el futuro. Normalmente, a la carpeta que contiene los recursos del juego (Sprites, Scripts, Escenas, sonido, etc.) se le llama Assets. En proyectos más grandes puede ser recomendable dividir más aún las carpetas.</p>
<hr>
<h4>El inspector</h4>
<p>El inspector está a la derecha. Podrás ver que al seleccionar un nodo cambia. Esto es porque el inspector muestra las propiedades del nodo que has seleccionado. Las propiedades están organizadas por categorías.</p><p> Esto es porque los nodos que puedes usar (e incluso puedes crear los tuyos propios) heredan unos de otros. Es decir, un nodo que hereda de otro tiene las características del nodo "superior", más las suyas propias.</p><p>Esto se refiere a la estructura y comportamiento. No es lo mismo un Node2D, que es el nodo genérico para uso en 2D que Node3D, su equivalente en 3D. Sin embargo, ambos tienen unas características en común que heredan de Node, el nodo base de todos los demás tipos.</p>
<img src="https://github.com/ASX21/TanksDemoGodot/blob/main/ReadMeImages/Inspector.png"/>
<p><b>Pequeña nota: en el inspector podemos ver también las variables con la palabra clave "export" añadidas en el código. De esta forma podemos darle valor a través del editor. Se puede ver por ejemplo en la captura superior. Los campos Ui Scene y Projectile Scene son variables del script asociado al nodo.</b></p>
<h4>Las señales y grupos</h4>
<p>Esta es la otra pestaña que está junto al inspector. En este panel podemos ver dos cosas: señales y grupos.</p>
<h5>Señales</h5>
<p>Las señales sirven para notificar de que algo ha ocurrido de uno nodo a otro. Para eso primero hay que hacer que el nodo que va a recibir la señal escuche al nodo que la va a emitir. Esto se hace conectando la señal. Las señales <b>SIEMPRE</b> se conectan a una o más funciones. En esa función definiremos que es lo que va a ocurrir cuando se emita la señal. Una señal puede ser presionar un botón en la interfaz, entrar en colisión con algo u incluso puedes definir tus propias señales.</p>
<h5>Grupos</h5>
<p>Los grupos sirven para clasificar nodos. Podemos por ejemplo hacer un grupo de enemigos y que cuando uno nos vea, todos sean alertados. Esta es una de las funcionalidades de los grupos.</p>
<img src="https://github.com/ASX21/TanksDemoGodot/blob/main/ReadMeImages/NodeSignals.png"/>
<h3>El lenguaje de progamación de Godot</h3>