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
			dir("build"){
				sh "ls && cd .. && ls"
				sh "ctest -T test --no-compress-output || /usr/bin/true"
			}
		}
		
		stage("Code analysis"){
			sh "xsltproc ./helper/ctest-to-junit.xsl ./build/Testing/`head -n 1 < ./build/Testing/TAG`/Test.xml > ./TestResults.xml"
			step([$class: 'JUnitResultArchiver', testResults: './TestResults.xml'])
			sh "cd build && make coverage"
		}
	}

    stage("Cleanup"){
        deleteDir()
	}
}