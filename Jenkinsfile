node {
    stage("Prepare"){
        checkout scm
        def env  = docker.build 'simons-node'

        env.inside {
            stage("Make"){
				sh "mkdir -p build && cd build && cmake .. && make"
			}
        }
	}

    stage("Cleanup"){
        deleteDir()
	}
}