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
<hr>
<h3>La interfaz del editor</h3>
<hr>
<h3>El lenguaje de progamación de Godot</h3>