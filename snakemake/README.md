Example usage:

           snakemake --configfile config.yaml --cluster-config cluster.yaml --cluster "bsub -q {cluster.queue} -oo {cluster.output} -eo {cluster.error} -M {cluster.memory} -R {cluster.resources} -J {cluster.jobname}"  -j 12


