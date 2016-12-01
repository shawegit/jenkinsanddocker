node {
	def image
	def winimage
	
    stage("Checkout"){
        checkout scm
	}
	
    stage("Prepare Docker"){
        image  = docker.build 'simons-node'
	}
	
	image.inside {
		stage("Build"){
			sh "mkdir -p build && cd build && cmake -DBUILD_TESTS=ON -DCMAKE_BUILD_TYPE=Release .. && make"
		}
		
		stage("Test"){
			sh "./build/dockerandjenkinsapp"
		}
	}


    stage("Cleanup"){
        deleteDir()
	}
}