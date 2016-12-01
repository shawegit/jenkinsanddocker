node {
	def image
    stage("Checkout"){
        checkout scm
	}
    stage("Prepare Docker"){
        image  = docker.build 'simons-node'
	}

	image.inside {
		stage("Build"){
			sh "mkdir -p build && cd build && cmake .. && make"
		}
		
		stage("Test"){
			sh "./build/dockerandjenkins"
		}
	}


    stage("Cleanup"){
        deleteDir()
	}
}