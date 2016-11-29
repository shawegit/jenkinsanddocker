node {
    stage("Prepare"){
        checkout scm
        def env  = docker.build 'simons-node'

        env.inside {
            stage("Validate"){
				sh "echo Validate stuff"
			}
			
            stage("Test"){
				sh "Test"
			}
        }
	}

    stage("Cleanup"){
        deleteDir()
	}
}