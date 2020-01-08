version 1.0

# HelloWorld with variable workflow
workflow HelloWorld {
  call WriteGreeting
}

task WriteGreeting {

  input {
      String greeting
  }

  command {
     echo "${greeting}"
  }

  output {
     File output_greeting = stdout()
  }
}