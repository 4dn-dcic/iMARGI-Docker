#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/imargi:v1.1.1_dcic"

- class: "InlineJavascriptRequirement"

inputs:
  fastq_R1:
    type: File
    inputBinding:
      separate: true
      prefix: "-1"
      position: 1

  fastq_R2:
    type: File
    inputBinding:
      separate: true
      prefix: "-2"
      position: 2

  output_dir:
    type: string
    inputBinding:
      separate: true
      prefix: "-o"
      position: 3
    default: "."

  nThreads:
    type: int
    inputBinding:
      separate: true
      prefix: "-t"
      position: 4
    default: 4

outputs:
  clean_fastq_R1:
    type: File
    outputBinding:
      glob: "$(inputs.output_dir + '/' + '*clean__R1.fastq.gz')"

  clean_fastq_R2:
    type: File
    outputBinding:
      glob: "$(inputs.output_dir + '/' + '*clean__R2.fastq.gz')"

baseCommand: ["imargi_clean.sh"]
