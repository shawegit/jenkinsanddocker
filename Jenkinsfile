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
			//Running ctest with the option -T Test will make CTest generate an XML output file
			//in a sub-folder Testing inside the build folder
			//The || /usr/bin/true is necessary to prevent Jenkins from aborting the build 
			//prematurely (without running the xUnit plug-in) if some tests fail.
			sh "cd build && ctest -T test --no-compress-output || /usr/bin/true"
			sh "xsltproc ./helper/ctest-to-junit.xsl ./build/Testing/`head -n 1 < ./build/Testing/TAG`/Test.xml > TestResults.xml"
			junit 'TestResults.xml'
		}
		
		stage("Code analysis"){
			sh "mkdir -p reports"
			sh "cd build && make coverage && mv coverage.xml ../reports/"
			//sh "cppcheck --enable=all --inconclusive --xml --xml-version=2 -I ./include ./src 2> /reports/cppcheck.xml"
			sh "mv TestResults.xml ./reports/"
		}
		
		stage("Archive Build"){
			sh "zip archiv.zip build/dockerandjenkinsapp build/libdockerandjenkinslib.so"
			archiveArtifacts 'archiv.zip' 
			// Maybe something like 
			//sh "curl -T archiv.zip -u username:password ftp://our_archive_server//commitid//whatever"
			// Or using artifactory server with pipeline DSL
		}
	}
	
	stage("SonarQubing"){
		sh "echo 'sonar.projectKey=shawe:jenkinsanddocker' > sonar-project.properties"
		sh "echo 'sonar.projectVersion=1.0' >> sonar-project.properties"
		sh "echo 'sonar.projectName=Jenkins and Docker' >> sonar-project.properties"
		sh "echo 'sonar.sources=src' >> sonar-project.properties"
		sh "echo 'sonar.cxx.includeDirectories=include' >> sonar-project.properties"
		sh "echo 'sonar.cxx.coverage.reportPath=/reports/coverage.xml' >> sonar-project.properties"
		sh "echo 'sonar.cxx.xunit.reportsPaths=/reports/TestResults.xml' >> sonar-project.properties"
		sh "cat sonar-project.properties"
		sh "cat /reports/TestResults.xml"
		sh "cat /reports/coverage.xml"
		def scannerHome = tool 'sonarscanner';
		withSonarQubeEnv('sonarserver') {
		  sh "${scannerHome}/bin/sonar-scanner"
		}
	}
		
    stage("Cleanup"){
        deleteDir()
	}
}