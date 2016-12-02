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
			sh "mkdir -p build && cd build && cmake -DBUILD_TESTS=ON -DCMAKE_BUILD_TYPE=Release .. && make"
		}
		
		stage("Test"){
			sh "cd build && ctest -T test --no-compress-output || /usr/bin/true"
		}
		
		stage("Code analysis"){
			sh "mkdir -p reports"
			sh "xsltproc ./helper/ctest-to-junit.xsl ./build/Testing/`head -n 1 < ./build/Testing/TAG`/Test.xml > ./reports/TestResults.xml"
			//junit 'reports/TestResults.xml'
			step([$class: 'XUnitBuilder',
					thresholds: [
						[$class: 'SkippedThreshold', failureThreshold: '0'],
						[$class: 'FailedThreshold', failureThreshold: '0']],
					tools: [
					[$class: 'JUnitType', pattern: 'reports/TestResults.xml']]]
			)
			sh "cd build && make coverage && cp coverage.xml ../reports/coverage.xml"
			sh "cppcheck --enable=all --inconclusive --xml --xml-version=2 -I ./include ./src 2> /reports/cppcheck.xml"
		}
	}
		
    stage("Cleanup"){
        deleteDir()
	}
}