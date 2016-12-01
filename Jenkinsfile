node {
	def env
    stage("Prepare Docker"){
        checkout scm
        env  = docker.build 'simons-node'
	}

	env.inside {
		stage("Make"){
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