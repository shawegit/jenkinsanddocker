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
		stage("Prepare Linux Docker"){
			dir("images/linux"){
				image  = docker.build 'linux-build-node'
			}
		}
		
		image.inside {
			sh "mkdir -p reports"
			stage("Linux Unit Tests"){
				sh "mkdir -p build && cd build && cmake -DBUILD_TESTS=ON -DCMAKE_BUILD_TYPE=Release .. && make"
				//Running ctest with the option -T Test will make CTest generate an XML output file
				//in a sub-folder Testing inside the build folder
				//The || /usr/bin/true is necessary to prevent Jenkins from aborting the build 
				//prematurely (without running the xUnit plug-in) if some tests fail.
				//sh "cd build && valgrind --xml=yes --xml-file=../reports/valgrind.xml ctest -T test --no-compress-output || true"
				sh "cd build && ctest -T test --no-compress-output || true"
				sh "xsltproc ./helper/ctest-to-junit.xsl ./build/Testing/`head -n 1 < ./build/Testing/TAG`/Test.xml > reports/TestResults.xml"
			}
			
			stage("Code Analysis"){
				sh "cd build && make coverage && mv coverage.xml ../reports/"
				sh "cppcheck --enable=all --inconclusive --xml --xml-version=2 -I ./include ./src 2> reports/cppcheck.xml"
			}
			
		}
		
		stage("SonarQubing"){
			sh "echo 'sonar.projectKey=shawe:jenkinsanddocker' > sonar-project.properties"
			sh "echo 'sonar.projectVersion=1.0' >> sonar-project.properties"
			sh "echo 'sonar.projectName=Jenkins and Docker' >> sonar-project.properties"
			sh "echo 'sonar.sources=src' >> sonar-project.properties"
			sh "echo 'sonar.tests=test' >> sonar-project.properties"
			sh "echo 'sonar.language=c++' >> sonar-project.properties"
			sh "echo 'sonar.cxx.includeDirectories=include' >> sonar-project.properties"
			sh "echo 'sonar.cxx.coverage.reportPath=reports/coverage.xml' >> sonar-project.properties"
			sh "echo 'sonar.cxx.xunit.reportPath=reports/TestResults.xml' >> sonar-project.properties"
			//sh "echo 'sonar.cxx.xunit.provideDetails=true' >> sonar-project.properties"
			sh "echo 'sonar.cxx.cppcheck.reportPath=reports/cppcheck.xml' >> sonar-project.properties"
			//sh "echo 'sonar.cxx.valgrind.reportPath=reports/valgrind.xml' >> sonar-project.properties"
			
			def scannerHome = tool 'sonarscanner';
			withSonarQubeEnv('sonarserver') {
			  sh "${scannerHome}/bin/sonar-scanner"
			}
		}
		
		image.inside {
			stage("Linux Evaluate Unit Tests"){
				junit 'reports/TestResults.xml'
			}
			
			stage("Linux Build"){
				sh "mkdir -p build && cd build && cmake -DBUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release .. && make"
				sh "mkdir -p linuxbuild && cp build/dockerandjenkinsapp linuxbuild/dockerandjenkinsapp && cp build/libdockerandjenkinslib.so linuxbuild/libdockerandjenkinslib.so"
				stash name: "linuxbuild", includes: "linuxbuild/*"
				
				def server = Artifactory.newServer url: 'http://192.168.2.7:8081/artifactory/', username: 'admin', password: 'password'
				def uploadSpec = """{
				  "files": [
					{
					  "pattern": "reports/cppcheck.xml",
					  "target": "Testy"
					},
					{
					  "pattern": "reports/TestResults.xml",
					  "target": "Testy"
					},
					{
					  "pattern": "reports/coverage.xml",
					  "target": "Testy"
					}
				 ]
				}"""
				server.upload(uploadSpec)
			}
		}
		
		deleteDir()
	}
}, "Windows":{
	node("winnode"){
		deleteDir() 
		unstash "code"
		def image
		
		stage("Prepare Windows Docker"){
			dir("images/win"){
				unstash "code"
				bat "echo 'Start build'"
				bat "dir"
				image  = docker.build 'win-build-node'
			}
		}
		image.inside {
			stage("Windows Build"){
				bat "if not exist build md build"
				bat "cd build; cmake -G \"Visual Studio 14 2015 Win64\" -DBUILD_TESTS=ON .."
				bat "cd build; msbuild dockerandjenkins.sln /p:Configuration=Release /p:Platform=\"x64\" /p:ProductVersion=1.0.0.${env.BUILD_NUMBER}"
			}
			stage("Windows Unit Tests"){
				bat "cd build; ctest -T test --no-compress-output -C Release"
				//sh "xsltproc ./helper/ctest-to-junit.xsl ./build/Testing/`head -n 1 < ./build/Testing/TAG`/Test.xml > reports/TestResults.xml"
			}
		}
		
		stage("Publish"){
			// Need to check whether the tests have passed or not
			//stage("Windows Evaluate Unit Tests"){
			//	junit 'reports/TestResults.xml'
			//}
			// Here we need to publish to junit ...
			bat "if not exist winbuild md winbuild"
			bat "xcopy build\\Release\\dockerandjenkinsapp.exe winbuild\\dockerandjenkinsapp.exe; xcopy build\\Release\\dockerandjenkinslib.dll winbuild\\dockerandjenkinslib.dll"
			stash name: "winbuild", includes: "winbuild/*"
		}
		deleteDir()
	}
}
//,failFast: true

node("master"){
	stage("Deliver"){
		deleteDir()
		unstash "winbuild"
		unstash "linuxbuild"
		sh "zip linuxbuild.zip linuxbuild/*"
		sh "zip winbuild.zip winbuild/*"
		archiveArtifacts 'linuxbuild.zip, winbuild.zip' 
		// Maybe something like 
		//sh "curl -T archiv.zip -u username:password ftp://our_archive_server//commitid//whatever"
		// Or using artifactory server with pipeline DSL
		deleteDir()
	}
}