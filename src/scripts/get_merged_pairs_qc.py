import click
import json


@click.command()
@click.argument('pairs_stats')
@click.argument('outdir')
def main(pairs_stats, outdir):

    with open(pairs_stats) as fp:
        f2 = fp.readlines()
    qc_dict = {}
    ln = 0
    line_index = [3, 4, 5, 8, 9, 10]  # These are the lines we need from this file
    for line in f2:
        ln = ln + 1
        if ln in line_index:
            key = line.split('\n')[0].split('\t')[0]
            val = line.split('\n')[0].split('\t')[1]
            qc_dict[key] = val

    with open(f'{outdir}/marged_pairs_qc.json', 'w') as out:
        json.dump(qc_dict, out, indent=2)


if __name__ == "__main__":
    main()
