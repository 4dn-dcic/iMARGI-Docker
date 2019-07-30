#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
- class: DockerRequirement
  dockerPull: "4dndcic/imargi:v1.1.1_dcic_3"

- class: "InlineJavascriptRequirement"

inputs:
  distance_type:
    type: string
    inputBinding:
      separate: true
      prefix: "-D"
      position: 1
    default: "5end"

  distance_threshold:
    type: string
    inputBinding:
      separate: true
      prefix: "-d"
      position: 2
    default: "200000"

  pairs_file:
    type: File
    inputBinding:
      separate: true
      prefix: "-i"
      position: 3

  out_file:
    type: string
    inputBinding:
      separate: true
      prefix: "-o"
      position: 4
    default: "out.txt"

outputs:
  stats_file:
    type: File
    outputBinding:
      glob: "$('*.txt')"

baseCommand: ["imargi_stats.sh"]
