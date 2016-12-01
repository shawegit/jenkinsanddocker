node {
	def image
	def winimage
	
    stage("Checkout"){
        checkout scm
	}
	
    stage("Prepare Docker"){
        image  = docker.build 'simons-node'
	}
	
	stage("Prepare Other Docker"){
		
        winimage  = docker.build 'simons-win-node'
	}

	image.inside {
		stage("Build"){
			sh "mkdir -p build && cd build && cmake .. && make"
		}
		
		stage("Test"){
			sh "./build/dockerandjenkinsapp"
		}
	}


    stage("Cleanup"){
        deleteDir()
	}
}