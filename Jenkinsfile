node {
	def env
    stage("Prepare"){
        checkout scm
        env  = docker.build 'simons-node'
	}
	stage("Action"){
        env.inside {
            stage("Make"){
				sh "mkdir -p build && cd build && cmake .. && make"
			}
			
			stage("Test"){
				sh "./build/dockerandjenkins"
			}
        }
	}

    stage("Cleanup"){
        deleteDir()
	}
}