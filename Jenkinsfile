node {
    stage("Prepare"){
        checkout scm
        def env  = docker.build 'simons-node'

        env.inside {
            stage("Validate"){
				sh "echo Validate stuff"
			}
			
            stage("Make"){
				sh "ls"
				sh "cmake"
				sh "make"
			}
        }
	}

    stage("Cleanup"){
        deleteDir()
	}
}