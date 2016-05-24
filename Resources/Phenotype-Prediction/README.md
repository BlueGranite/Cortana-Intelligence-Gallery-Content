# Predicting phenotypes from genomic data using FaST-LMM on Microsoft Azure's Linux Data Science Virtual Machine

Genome-Wide Association Studies (GWAS) attempt to find genome variants associated with a phenotype (i.e., a trait or disorder of interest). The identity of these variants may shed light on the phenotype's causes, suggesting new targets for treatment or subjects of future research. Medical professionals may also use knowledge of variant associations to predict, from a genome sequence, whether a patient may develop a given phenotype later in life.

A core challenge of GWAS is that there are millions of common variants in the human genome -- with novel mutations occurring every day -- while most research studies have fewer than 100,000 participants. The problem of identifying the phenotypic effect associated with each variant is therefore underdetermined. The existence of population structure, co-inheritance of adjacent variants in the genome, presence of selection, contributions of environmental conditions to phenotype, interactions between variants, and ignorance of unidentified variants are all common confounding factors in GWAS. Computational requirements, once another limiting factor, have fortunately been dramatically improved thanks to recent developments in the approximate solution of linear mixed models (Lippert et al., 2011; Widmer et al., 2014; Loh et al., 2015). The suggested readings at the end of this tutorial contain additional information on LMMs for those interested.

In this tutorial, we will use Microsoft Research's [FaST-LMM](http://research.microsoft.com/en-us/projects/fastlmm) to identify causal variants and make predictions using real human genomic data and simulated phenotypes. For wide reproducibility, we provide instructions for performing these analyses on a [Linux Data Science Virtual Machine](https://azure.microsoft.com/en-us/marketplace/partners/microsoft-ads/linux-data-science-vm/). We also include an optional walkthrough of our process for phenotype simulation using [Azure Machine Learning Studio](https://studio.azureml.net/). Please see the [FaST-LMM](http://research.microsoft.com/en-us/projects/fastlmm) webpage for additional examples.

## Setting up the Linux Data Science Virtual Machine

### Prerequisites

This tutorial will require:

 - An Azure subscription, which will be used to provision a Linux DSVM
   (a [one-month free
   trial](https://azure.microsoft.com/en-us/pricing/free-trial/) is
   available for new users)
 - A secure shell client for connection to the Linux DSVM (see below for
   suggestions)


Prior familiarity with common Linux commands and Python will be helpful for understanding and commands/scripts suggested here, though it is possible to follow along without this background.

The optional phenotype simulation walkthrough also uses:

 - A (free) [Azure Machine Learning Studio](https://studio.azureml.net/)
   account
 - Optionally, a [Microsoft Azure storage
   account](https://azure.microsoft.com/en-us/documentation/articles/storage-create-storage-account/)
   for transferring files between your DSVM and Azure Machine Learning
   Studio.

### Provisioning a Linux Data Science Virtual Machine

Click the button below to begin provisioning a Linux Data Science Virtual Machine in a new window:

[![Deploy to Azure](https://camo.githubusercontent.com/a941ea1d057c4efc2dcc0a680f43c97728ec0bd8/687474703a2f2f617a7572656465706c6f792e6e65742f6465706c6f79627574746f6e2e737667)
][1]

Log in with your Azure username and password if necessary. When prompted, choose the Azure subscription, resource group, username, password, and virtual machine name of your choice. We recommend selecting a VM size of "Basic A3" for this tutorial. When ready, click Next.

![First step of deployment](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/Images/azure_deploy1.PNG?raw=true)

A list of resources to be created will appear. Continue to initiate deployment. When deployment is complete, click the Manage Resources link that appears:

![Deployment complete](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/Images/azure_deploy2.PNG?raw=true)

The Azure Portal entry for your resource group will be loaded. Click on the entry for your virtual machine to load a pane describing its properties.

![Finding the DSVM IP address](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/Images/ip_address.PNG?raw=true)

Make a note of the public IP address listed in the second column under the *Essentials* header: you will use this to connect to the virtual machine using secure shell (ssh).

### Connecting to your virtual machine using ssh

If you use Mac OS X or Linux as your local operating system, you can issue an `ssh` command at the terminal to connect to your virtual machine. Windows users may prefer to connect through a browser-based secure shell client such as [FireSSH](https://addons.mozilla.org/en-us/firefox/addon/firessh/) or [Secure Shell for Google Chrome](https://chrome.google.com/webstore/detail/secure-shell/pnhechapfaindjhompbnflcldabbghjo), or by installing an ssh client such as [PuTTY](http://www.putty.org/) or ssh in the [Cygwin](https://www.cygwin.com/) command line.

Please see your ssh client's instructions for establishing a connection using this IP address and the username/password you previously selected. For example, using `ssh` from the Mac OS X, Linux, or Cygwin terminals, you can connect by substituing your usename and IP address into the following command:

$ ssh your_username@your_ip_address

Depending on your ssh client, the connection may resemble the following:

![Accessing the virtual machine via ssh in Cygwin](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/Images/ssh_cygwin.PNG?raw=true)

### Select Python 2.7 as default version

The Linux Data Science Virtual Machine has Python versions 2.7 and 3.5 pre-installed. To install the `pysnptools` and `fastlmm` packages, which require Python 2.7, we will switch the default Python environment from 3.5 to 2.7:

    $ source activate root

You will need to reactivate this environment if you begin a new `ssh` session or load a new `screen`.

### Install Python packages

After creating the Python 2.7 virtual environment, install the necessary Python 2.7 packages and their dependencies using `pip`:

    $ sudo /bin/anaconda/pip install pysnptools
    $ sudo /bin/anaconda/pip install fastlmm

If you will complete the optional phenotype simulation walkthrough, also install the `azure-storage` package:

    $ sudo /bin/anaconda/pip install azure-storage --upgrade

### Prepare a working directory in temporary storage

By default, your Linux DSVM comes with a large, temporary storage partition mounted under the directory `/mnt/resource`:

    $ df -h
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/sda1        30G  9.0G   22G  30% /
    devtmpfs        3.4G     0  3.4G   0% /dev
    tmpfs           3.5G     0  3.5G   0% /dev/shm
    tmpfs           3.5G  8.3M  3.4G   1% /run
    tmpfs           3.5G     0  3.5G   0% /sys/fs/cgroup
    /dev/sdb1       281G   65M  267G   1% /mnt/resource
    tmpfs           697M     0  697M   0% /run/user/1002

Data stored on this temporary partition will be lost when the DSVM is restarted or resized. It is an ideal space for performing operations involving large datasets that need not be retained or might later be transferred to a more permanent location, such as [Azure Blob Storage](https://azure.microsoft.com/en-us/documentation/articles/storage-python-how-to-use-blob-storage/) or [an attached storage disk](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-classic-attach-disk/). Ensure that you have read, write, and execute permissions for `/mnt/resource` by issuing the following command:

    $ sudo chmod 777 /mnt/resource

## Obtain the input genotyping data

We will use genotype data obtained from the [International HapMap Project](https://hapmap.ncbi.nlm.nih.gov/) to simulate phenotypes and perform GWAS analysis using FaST-LMM. The HapMap3 dataset, [available in PLINK format from the HapMap Project website](https://hapmap.ncbi.nlm.nih.gov/downloads/genotypes/hapmap3/plink_format/draft_2/), contains genotypes at > 1.4 M variable sites from 1,184 persons. For demonstration purposes, we have used PLINK to select only the 6,484 variants on chromosome 22 with minor allele frequencies between 5% and 50%.

Detailed instructions for reproducing the input data directly from the HapMap3 dataset are included below for those interested. Alternatively, the input dataset can be [downloaded directly](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/hapmap.tar.gz). We recommend downloading and unpacking this file in your temporary storage directory as follows:

    $ wget https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/hapmap.tar.gz -P /mnt/resource
    $ tar -zxf /mnt/resource/hapmap.tar.gz

You will find that the newly-created subdirectory `/mnt/resource/hapmap` contains two tab-delimited plaintext files, `chr22.map` and `chr22.ped`. The first is a four-column description of all genomic loci included in this dataset, including the chromosome where they are located, their [Reference SNP identifier](ftp://ftp.ncbi.nih.gov/pub/factsheets/Factsheet_SNP.pdf) (rsid), a placeholder for recombination distance information (absent in this file), and the position in basepairs of the variant on its chromosome:

    $ head -3 /mnt/resource/hapmap/chr22.map
    22      rs2236639       0       15452483
    22      rs5746664       0       15454622
    22      rs16984366      0       15476864

The second file, `chr22.ped`, contains information on each individual's genotype at each of the loci mentioned in the map file. The file begins with six columns describing the individual: family ID, individual ID, ID of mother if present, ID of father if present, sex (male: 1, female: 2) if known, and a placeholder for phenotype information (not applicable here). The remaining 12,968 columns describe the two alleles that each individual possesses for each of the 6,484 variants, in the order given in the map file.

    $ cut -f 1-10  /mnt/resource/hapmap/chr22.ped | head -3
    2427    NA19919 NA19908 NA19909 1       -9      G G     C C     T T     A A
    2431    NA19916 0       0       1       -9      G G     C C     T T     A G
    2424    NA19835 0       0       2       -9      G G     C C     T T     A G

The directory also contains binary versions of these files generated using PLINK (BED/BIM/FAM). The binary versions will be used as input by FaST-LMM, while the plaintext versions will be used for phenotype simulation.

### (Optional) Reproduce the input dataset from the original HapMap Project data

To recreate the input data provided above, begin by downloading and decompressing the PLINK format [MAP](https://hapmap.ncbi.nlm.nih.gov/downloads/genotypes/hapmap3/plink_format/draft_2/hapmap3_r2_b36_fwd.consensus.qc.poly.map.bz2) and [PED](https://hapmap.ncbi.nlm.nih.gov/downloads/genotypes/hapmap3/plink_format/draft_2/hapmap3_r2_b36_fwd.consensus.qc.poly.ped.bz2) files from the International HapMap Project website. The `bunzip2` command may require several minutes to decompress the PED file.

    $ mkdir /mnt/resource/hapmap
    $ wget https://hapmap.ncbi.nlm.nih.gov/downloads/genotypes/hapmap3/plink_format/draft_2/hapmap3_r2_b36_fwd.consensus.qc.poly.map.bz2 -P /mnt/resource/hapmap
    $ wget https://hapmap.ncbi.nlm.nih.gov/downloads/genotypes/hapmap3/plink_format/draft_2/hapmap3_r2_b36_fwd.consensus.qc.poly.ped.bz2 -P /mnt/resource/hapmap
    $ bunzip2 /mnt/resource/hapmap/*

We will use [PLINK](http://pngu.mgh.harvard.edu/~purcell/plink/) to filter variants based on minor allele frequency and chromosome location. Install PLINK by placing its binaries on a directory on the system path:

    $ wget https://www.cog-genomics.org/static/bin/plink160416/plink_linux_x86_64.zip
    $ unzip plink_linux_x86_64.zip
    $ sudo mv plink /usr/local/bin
    $ sudo mv prettify /usr/local/bin

Next, we'll use PLINK to select relatively common variants (those whose minor allele has frequency >5% in this dataset) on chromosome 22. We also require that each variant have genotype information available for all persons (enforced by setting the maximum missingness to 1 in 10,000). Generate both plaintext and binary versions of the PLINK results as follows:

    $ plink --file /mnt/resource/hapmap/hapmap3_r2_b36_fwd.consensus.qc.poly --geno 0.0001 --maf 0.05 --chr 22 --make-bed --out /mnt/resource/hapmap/chr22
    $ plink --bfile /mnt/resource/hapmap/chr22 --recode --out /mnt/resource/hapmap/chr22

## Obtain simulated phenotype data

To download [example phenotype simulation results](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/simulated_phenotypes.tar.gz), which you can use to proceed directly to this tutorial's section on FaST-LMM, just issue the commands below:

    $ wget https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/simulated_phenotypes.tar.gz -P /mnt/resource/
    $ tar -zxf /mnt/resource/simulated_phenotypes.tgz

Alternatively, you can follow the phenotype simulation walkthrough below to simulate your own phenotypes for use in the analysis.

## (Optional) Phenotype simulation walkthrough

An example experiment illustrating phenotype simulation has been published on the [Cortana Intelligence Gallery](https://gallery.cortanaintelligence.com/). The heart of this walkthrough will be a description of the steps executed within that experiment, which accesses genotype information from Azure Blob Storage and writes its simulated phenotypes to the same location. Instructions are also included for transferring the necessary files to and from your Data Science Virtual Machine; you can skip those steps if you are primarily interested in the simulation process.

### (Optional) Transfer genotype information from Linux DSVM to Azure Blob Storage

We begin by describing how you can transfer files from your Linux Data Science Virtual Machine to blob storage using the `azure-storage` Python package and SAS tokens. If you prefer, you may skip this step: you can continue the phenotype simulation walkthrough without it.

If you have not already done so, you will need to create a Storage account with a public-access container. To do this, log into the Azure Portal and click on the "+ New" button, then search for the "Storage account" option. Select this option and click "Create", following the on-screen prompts to provision the storage account. Once the storage account has been launched, navigate to its settings page by clicking on its entry on the "All resources" page. Under the "Services" heading, click "Blobs" to bring up a pane containing a "+ Container" button, which will allow you to create a new container with the "Container" access type. Make a note of your storage account and container names.

You may access this container from Python using your Azure username and password; however, for privacy reasons you will likely prefer not to store this information in plaintext within a Python script. The example commands below use an SAS token to access the blob instead. You can most easily generate an SAS token by installing [http://storageexplorer.com/](Microsoft Azure Storage Explorer), logging into your Azure account, right-clicking on the container of interest, and selecting the "Get Shared Access Signature" option. To use the example commands in this tutorial, you will need an SAS token granting read and write access to your container.

Launch the Python (2.7) interpreter and issue the following commands to copy the genotype data to your container:

    $ python
    >>> from azure.storage.blob import BlockBlobService
    >>> sas_service = BlockBlobService(account_name = 'your_azure_account_name',
                                       sas_token = 'st=2016...taypc%3D',
                                       protocol = 'http')
    >>> sas_service.create_blob_from_path('your_container_name', 'chr22.map', '/mnt/resource/hapmap/chr22.map')
    >>> sas_service.create_blob_from_path('your_container_name', 'chr22.ped', '/mnt/resource/hapmap/chr22.ped')

When you are done, exit the Python interpreter using the `exit()` command.

### (Optional) Walkthrough of the phenotype simulation experiment in Azure Machine Learning Studio

Click the "Open in Studio" button on the [phenotype simulation experiment's gallery page](https://gallery.cortanaintelligence.com/Experiment/Simulating-phenotypes-from-genomic-data-1) to copy the experiment to your Azure Machine Learning Studio workspace. If you completed the optional section above, you may modify the **Enter Data Manually** module at upper-left (1) to access the genotype data from your own storage account. The experiment will then be able to write the simulated phenotypes to your container as well.

![First half of the phenotype simulation experiment](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/Images/first_part_of_experiment_annotated.png?raw=true)

The first two **Execute Python Script** modules (2-3) in this experiment download the genotype data from Azure Blob Storage and export it in AML Studio's dataset format. The genotype information is then converted to a numerical representation: the number of minor alleles is determined for each individual at each locus, and these minor allele counts are normalized to mean zero and variance one for each locus (4). The variant names from the map file are then used to label the corresponding columns of genotype data (5).

A second **Enter Data Manually** module (6) allows the user to specify how much variance in overall phenotype is attributable to:

 - Randomly-selected "causal" variants with equal effect on phenotype
   (the number of such variants is also specified)
 - Random genetic effects (heritable differences in phenotype not attributable to genotyped variants)
 - Randomly-generated, binary environmental covariates of equal effect (known environmental conditions that impact phenotype)
 - Random environmental effects (unknown environmental conditions that impact phenotype, simulated as noise)

![Second half of the phenotype simulation experiment](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/Images/second_part_of_experiment_annotated.png?raw=true)

With these user-specified parameters, the experiment workflow splits into three branches that simulate the phenotypic contributions of causal variants (7), environmental covariates (8), and random effects (9), respectively. These contributions to phenotype are then summed to get overall phenotype values. The causal variants, covariates, and phenotypes will be recorded to blob storage if the account information was updated in the first **Enter Data Manually** module. (The default account information in the gallery experiment allows reading but not writing from blob storage.)

### (Optional) Transferring simulation results to the Linux DSVM

If you provided your Azure account login information to the module labeled (1) above and re-ran the experiment, files detailing the causal variants, covariates, and the overall phenotypes should have been added to your blob storage account. To copy them to your Linux DSVM, issue the following commands:

    $ mkdir /mnt/resource/simulated_phenotypes
    $ python
    >>> from azure.storage.blob import BlockBlobService
    >>> sas_service = BlockBlobService(account_name = 'your_azure_account_name',
                                       sas_token = 'st=2016...taypc%3D',
                                       protocol = 'http')
    >>> sas_service.get_blob_to_path('your_container_name', 'phenotypes.tsv',
                                     '/mnt/resource/simulated_phenotypes/phenotypes.tsv')
    >>> sas_service.get_blob_to_path('your_container_name', 'covariates.tsv',
                                     '/mnt/resource/simulated_phenotypes/covariates.tsv')
    >>> sas_service.get_blob_to_path('your_container_name', 'causal_variants.tsv',
                                     '/mnt/resource/simulated_phenotypes/causal_variants.tsv')

## Estimating variant effects

The `single_snp()` function can be used to perform single-variant association testing using LMM:

    $ python
    >>> from fastlmm.association import single_snp
    >>> import matplotlib.pyplot as plt
    >>> import numpy as np
    
    >>> bed_filename_prefix = '/mnt/resource/hapmap/chr22'
    >>> phenotypes_filename = '/mnt/resource/simulated_phenotypes/phenotypes.tsv'
    >>> covariates_filename = '/mnt/resource/simulated_phenotypes/covariates.tsv'
    >>> output_pvalues_filename = '/mnt/resource/simulated_phenotypes/pvalues.tsv'
    
    >>> results_df = single_snp(bed_filename_prefix, phenotypes_filename, covar=covariates_filename,
                                output_file_name=output_pvalues_filename)

The results dataframe (and the generated output file) contain estimated effect sizes for each variant, sorted by the probability of the data given the null hypothesis that the variant has no effect.

*Manhattan plots*, commonly used to visualize GWAS results, are scatter plots of *-log p* vs. genomic position for each variant. (On these plots, causal variants and their neighbors form "peaks" above a background of unassociated variants thought to resemble the NYC skyline.) Below, we describe a modification of the `fastlmm` `manhattan_plot()` function that displays true causal variants in red and all other variants in blue. As a first step, we annotate the `single_snp()` results to indicate which variants are truly causal:

    causal_variants_filename = '/mnt/resource/simulated_phenotypes/causal_variants.tsv'
    causal_variants_file = open(causal_variants_filename, 'r')
    causal_variants = [line.strip().split('\t')[0] for line in causal_variants_file]
    causal_variants_file.close()
    
    results_df['causal'] = False
    results_df.loc[results_df[results_df['SNP'].isin(causal_variants)].index, 'causal'] = True

We next extract the chromosome position and negative log p-value of each causal and non-causal variant for later plotting:

    array = np.array(results_df.as_matrix(['ChrPos', 'PValue', 'causal']))
    x = array[:, 0].tolist()
    y = -1 * np.log10(array[:,1].tolist())
    
    causal_idx = [i for i, is_causal in enumerate(array[:, 2].tolist()) if is_causal]
    x_causal = [x[i] for i in causal_idx]
    y_causal = [y[i] for i in causal_idx]
    
    not_causal_idx = [i for i, is_causal in enumerate(array[:, 2].tolist()) if not is_causal]
    x_not_causal = [x[i] for i in not_causal_idx]
    y_not_causal = [y[i] for i in not_causal_idx]

Finally, we create and format the scatterplot. A guideline indicating the threshold for p-value significance is also included.

    max_y = y.max()
    plt.scatter(x_not_causal, y_not_causal, marker='o', color='b', edgecolor = 'none',
                s=y_not_causal/max_y*20+0.5, alpha=0.5)
    plt.scatter(x_causal, y_causal, marker='o', color='r', edgecolor = 'none',
                s=y_causal/max_y*20+0.5)
    
    plt.ylim([0.0, None])
    plt.xlabel('variant position on chromosome')
    plt.ylabel('-log10(P value)')
    
    pvalue_line= 1e-2 / array.shape[0] # Bonferroni correction for significance
    plt.axhline(-np.log10(pvalue_line), linestyle='--')
    
    plt.savefig('/mnt/resource/simulated_phenotypes/manhattan_plot.png')

The resulting Manhattan plot is shown below:

![Manhattan Plot](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/Images/manhattan_plot.png?raw=true)

In this example, the p-values for all true causal variants pass the threshold for significance: their p-values are sufficiently low that they lie above the threshold line on the *-\log p* axis. The plot also reveals two common types of "false positives", i.e. variants which are not causal that nonetheless have significant p-values. Below, we will introduce the cause of these false positives with reference to the top ten most significant variants, summarized below:

    >>> results_df[['SNP', 'ChrPos', 'PValue', 'causal']].head(10)
              SNP    ChrPos        PValue causal
    0   rs3764847  16043117  7.253077e-28   True
    1   rs5755790  34336678  3.092978e-21  False
    2   rs2899254  34336268  3.092978e-21  False
    3   rs5755794  34341868  1.963327e-20   True
    4  rs10483132  25957598  9.430616e-19   True
    5   rs1967963  34353106  7.393145e-16  False
    6   rs2024645  41542725  8.590407e-15  False
    7   rs4821422  34330493  1.769175e-14  False
    8   rs4824079  48477195  4.037474e-14   True
    9    rs738384  41649102  4.414443e-14  False

The first type of "false positive" consists of variants that lie near true causal variants on the chromosome. Neighboring variants are usually coinherited because the probability of a recombination event occurring in the short region between them is low. The neighboring variants are therefore indirectly associated with phenotype: this association decays with distance along the chromosome, creating the Manhattan plot's characteristic rising peaks. In this example, variants `rs5755790`, `rs2899254`, `rs1967963`, and `rs4821422` are all non-causal neighbors of the true causal variant `rs5755794`.

The second type of "false positive" involves population-level correlations between variants. One of our randomly-chosen causal variants, [`rs5755794`](http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?searchType=adhoc_search&type=rs&rs=rs5755794#Diversity), has a minor allele that is much more common in European populations (minor allele frequency 0.45 vs. 0.07 in Africa/Asia). The average phenotype of Europeans will therefore be different from that of other populations, and any variant that has an unusual frequency in Europeans may appear to be associated with phenotype. In this example, one of the spurious peaks on the Manhattan plot appears to be caused by [`rs738384`](http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?searchType=adhoc_search&type=rs&rs=rs738384#Diversity), which is also more variable in Europeans (MAF 0.43 vs. 0.09), and its own physically-associated variants such as `rs2024645`.

There are roughly twenty significant non-causal variants for every causal variant in our simulated dataset: clearly this precision rate is insufficient to make an acceptable determination of causality. In practice, follow-up studies are invariably required to establish causality of associated variants identified by GWAS. Fortunately, if our goal is simply to predict phenotypes, the "false positive" variants need not be removed from consideration because their association with phenotype is real and informative.

## Predicting phenotypes using FaST-LMM

To assess the accuracy of phenotype predictions, we split the 1,184 persons in our dataset into training and validation groups. FaST-LMM will fit covariate and SNP effects based on the individuals in the training set, then generate predictions based on never-before-seen individuals in the validation set. The genotypes mentioned in the BED file can be split into two datasets as follows:

    import numpy as np
    from pysnptools.snpreader import Pheno, Bed
    
    marker_reader = Bed('/mnt/resource/hapmap/chr22', count_A1=False)
    n_individuals = len(marker_reader.iid)
    n_training = int(np.ceil(n_individuals * 0.8))
    random_perm = np.random.permutation(n_individuals)
    marker_training = marker_reader[random_perm[:n_training], :]
    marker_validation = marker_reader[random_perm[n_training:], :]

Next, we train a FaST-LMM model using the randomly-chosen training set. Note that FaST-LMM will extract the phenotype and covariate information for training set individuals from the provided text files, which contain information on all individuals. We print the fitted covariate effects and FaST-LMM's estimate of the phenotype's heritability for reference.

    from fastlmm.inference import FastLMM
    fastlmm = FastLMM()
    fastlmm.fit(K0_train=marker_training,
                y='/mnt/resource/simulated_phenotypes/phenotypes.tsv',
                X='/mnt/resource/simulated_phenotypes/covariates.tsv')
    print('Fitted mean phenotype: %f' % fastlmm.beta[-1])
    print('Fitted covariate effects:')
    print(fastlmm.beta[:-1])
    print('Estimated h^2: %f' % fastlmm.h2)

Results may vary due to the random partitioning of individuals between training and validation sets. Sample output is shown below:

    Fitted mean phenotype: 0.002747
    Fitted covariate effects:
    [ 0.18372197  0.1894779   0.14536035  0.15169319  0.15920573  0.21236183
      0.15430505  0.17525119  0.14725647  0.16427577]
    Estimated h^2: 0.719900

Let's take a moment to assess the accuracy of these results. Our simulation method creates phenotypes with expected mean 0 and unit variance; this variance comprises several sources of variation:

 - Ten randomly-selected "causal" variants with equal effect jointly account for 30% of variance in phenotype
 - Random genetic effects account for 20% of variance in phenotype
 - Ten randomly-generated, binary environmental covariates of equal effect jointly account for 30% of variance in phenotype
 - Random noise accounts for 20% of variance in phenotype

To achieve the desired fraction of variance in phenotype, the simulation used a covariate effect of 0.173: the estimated covariate effects vary around this value but average 0.168. The heritability h² is the fraction of heritable variation in phenotype (after accounting for the effects of covariates):

![Heritability](https://github.com/Azure/Cortana-Intelligence-Gallery-Content/blob/master/Resources/Phenotype-Prediction/Images/heritability.PNG?raw=true)

This value is relatively close to the FaST-LMM estimate of 0.720.

Finally, we will perform predictions on the validation set and compare these to the "true" simulated phenotypes. We will use the coefficient of determination (R²), i.e. the proportion of variance in phenotype accounted for by the predictions, as our metric for accuracy. Since we do not expect that the variation attributable to noise will be captured by our model, R² ≤ 0.3 + 0.3 + 0.2 = 0.8. We expect that prediction of random genetic effects will be poor in general (though the dataset does include some close relatives), so a more realistic estimate of the achievable R² is 0.3 + 0.3 = 0.6. How close do our predictions come to this upper bound?

    from scipy.stats import pearsonr
    
    mean, covariance = fastlmm.predict(K0_whole_test=marker_validation,
                                       X='/mnt/resource/simulated_phenotypes/covariates.tsv')
    all_phenotypes = Pheno('/mnt/resource/simulated_phenotypes/phenotypes.tsv')
    validation_true_phenotypes = all_phenotypes[all_phenotypes.iid_to_index(mean.iid), :].read()
    r_value, _ = pearsonr(validation_true_phenotypes.val[:, 0].tolist(), mean.val[:, 0].tolist())
    print('R^2 for phenotype predictions: %f' % r_value**2)

Results may vary depending on the random partitioning of training and validation sets; we found R² = 0.544, an impressive performance for FaST-LMM given the high proportion of non-informative variants.

## Next Steps

After you have completed the tutorial, we recommend stopping or deleting your virtual machine so that you will not continue to be charged for its use. Please note that stopping your virtual machine can result in loss of files from the temporary storage drive used in this tutorial: we recommend copying any results you wish to save to another location, e.g. an Azure Storage Account or a persistent drive.

Additional examples illustrating FaST-LMM’s full functionality are available in the [FaST-LMM Manual](http://nbviewer.jupyter.org/github/MicrosoftGenomics/FaST-LMM/blob/master/doc/ipynb/FaST-LMM.ipynb). For more sample genomic analyses in Azure Machine Learning Studio, including [prediction of ethnic admixture from direct-to-consumer commercial genotyping data](https://gallery.cortanaintelligence.com/Collection/Individual-Ancestry-Prediction-from-Genetic-Data-1), please see the [Cortana Intelligence Gallery](https://gallery.cortanaintelligence.com).

# Further reading

Lippert C et al. (2011). [FaST Linear Mixed Models for Genome-Wide Association Studies.](http://www.nature.com/nmeth/journal/v8/n10/full/nmeth.1681.html) *Nature Methods* **8**, 833–835.

Loh P-R et al. (2015). [Efficient Bayesian mixed-model analysis increases association power in large cohorts.](http://www.nature.com/ng/journal/v47/n3/abs/ng.3190.html) *Nature Genetics* **47**, 284–290.

Widmer C et al. (2014). [Further Improvements to Linear Mixed Models for Genome-Wide Association Studies.](http://www.nature.com/articles/srep06874) *Scientific Reports* **4**(6874).

Zou et al. (2014).	[Epigenome-wide association studies without the need for cell-type composition](http://www.nature.com/articles/nmeth.2815.epdf). *Nature Methods* **11** (3), 309-311. 

  [1]: https://azuredeploy.net/?repository=https://github.com/Azure/Azure-MachineLearning-DataScience/tree/master/Data-Science-Virtual-Machine/Linux
