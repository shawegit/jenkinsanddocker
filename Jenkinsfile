node("master"){
    stage("Checkout"){
        checkout scm
	}
	stash name: "code", excludes: "build"
}

parallel "Linux":{
	node("master"){
		deleteDir()
		unstash "code"
		def image
		stage("Prepare Docker"){
			image  = docker.build 'simons-node'
		}
		
		image.inside {
			stage("Linux Build"){
				sh "mkdir -p build && cd build && cmake -DBUILD_TESTS=ON -DCMAKE_BUILD_TYPE=Release .. && make"
				sh "mkdir -p linuxbuild && cp build/dockerandjenkinsapp linuxbuild/dockerandjenkinsapp && cp build/libdockerandjenkinslib.so linuxbuild/libdockerandjenkinslib.so"
				stash name: "linuxbuild", includes: "linuxbuild/*"
			}
			
			stage("Linux Test"){
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
				sh "cppcheck --enable=all --inconclusive --xml --xml-version=2 -I ./include ./src 2> reports/cppcheck.xml"
				sh "mv TestResults.xml ./reports/"
			}
		}
		
		stage("SonarQubing"){
			sh "echo 'sonar.projectKey=shawe:jenkinsanddocker' > sonar-project.properties"
			sh "echo 'sonar.projectVersion=1.0' >> sonar-project.properties"
			sh "echo 'sonar.projectName=Jenkins and Docker' >> sonar-project.properties"
			sh "echo 'sonar.sources=src' >> sonar-project.properties"
			sh "echo 'sonar.cxx.includeDirectories=include' >> sonar-project.properties"
			sh "echo 'sonar.cxx.coverage.reportPath=reports/coverage.xml' >> sonar-project.properties"
			sh "echo 'sonar.cxx.xunit.reportsPaths=reports/TestResults.xml' >> sonar-project.properties"
			sh "echo 'sonar.cxx.cppcheck.reportPath=reports/cppcheck.xml' >> sonar-project.properties"
			sh "echo 'tests=test' >> sonar-project.properties"
			def scannerHome = tool 'sonarscanner';
			withSonarQubeEnv('sonarserver') {
			  sh "${scannerHome}/bin/sonar-scanner"
			}
		}
		deleteDir()
	}
}, "Windows":{
	node("shawewin"){
		deleteDir() 
		unstash "code"
		stage("Windows Build"){
			bat "echo %PATH%"
			bat "if not exist build md build"
			bat "cd build && cmake -G \"Visual Studio 14 2015 Win64\" -DBUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release .."
			bat "cd build && msbuild dockerandjenkins.sln /p:Configuration=Release /p:Platform=\"x64\" /p:ProductVersion=1.0.0.${env.BUILD_NUMBER}"
			bat "if not exist winbuild md winbuild"
			bat "xcopy build\\Release\\* winbuild"
			stash name: "winbuild", includes: "winbuild/*"
		}
		deleteDir()
	}
},
failFast: true

node("master"){
	stage("Deliver"){
		deleteDir()
		unstash "winbuild"
		unstash "linuxbuild"
		sh "zip linuxbuild.zip linuxbuild/*"
		sh "zip winbuild.zip winbuild/*"
		sh "ls winbuild"
		sh "ls linuxbuild"
		archiveArtifacts 'linuxbuild.zip, winbuild.zip' 
		// Maybe something like 
		//sh "curl -T archiv.zip -u username:password ftp://our_archive_server//commitid//whatever"
		// Or using artifactory server with pipeline DSL
		deleteDir()
	}
}