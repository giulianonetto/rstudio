##### LOAD PACKAGES #####

suppressPackageStartupMessages({
  suppressWarnings({
    library(phyloseq)
    library(tidyverse)
    library(ggpubr)
    library(RColorBrewer)
    library(docstring)
    library(rlang)
  })
})


##### DEFINE FUNCTIONS #####

load_phyloseq <- function(otutable, taxtable, metadata = NULL,
                          taxa_as_rows = FALSE,
                          meta_smpls_only = FALSE,
                          remove_zeros = c("samples", "taxa"),
                          merge_dilutions = FALSE,
                          bacteria_only = TRUE,
                          treefile = NULL, speciesonly = FALSE,
                          remove_samples = NULL,
                          include_samples = NULL,
                          remove_metadata_vars = NULL) {
  #' Load microbiome data into phyloseq object.
  #'
  #' @description Wrapper which checks possible issues and runs simple 
  #' preprocessings for analyses with phyloseq objects. 
  #' 
  #' @param otutable Path to otu table.
  #' @param metadata Path to metadata - columns sample, group1-p required.
  #' @param taxtable Path to taxonomy table (oligotypes' lineages).
  #' @param taxa_as_rows Enforce taxa (oligos) to be on the rows, and samples on columns.
  #' @param meta_smpls_only Keep only those samples which are present in metadata table.
  #' @param remove_zeros vector of items whose zeroed entries should be removed. 
  #' Defaults to c("samples", "taxa"). Set to NULL or FALSE to keep zeroed samples and zeroed taxa.
  #' @param bacteria_only Whether to keep only bacterial DNA. Defaults to TRUE.
  #' @param treefile Path to (optional) phylogenetic tree (used for UniFrac calculations, for instance).
  #' @param speciesonly Aggregates data to species level - removes unclassified oligos at such ranking (to be generalized).
  #' @param remove_samples Pass IDs of samples to be removed.
  #' @param include_samples Pass IDs of samples to be kept.
  #' @param remove_metadata_vars Pass a PATTERN to use for identification of unused columns
  #' in the metadata table. It will exclude all metadata variables that match the given pattern. 
  #' 
  #' @details Currently, otutable, metadata, and taxtable are required. These
  #' can be obtained from the dmd table using the script retrieve_sunburst_input.py.
  #' You can remove/keep specific samples, only those which are in the
  #' metadata file, or just keep all samples - it will warn you when
  #' there's missing pieces in the files you provided.
  
  dat <- read.csv(otutable, sep = "\t", header = T, na.strings = '', stringsAsFactors = F)
  if (taxa_as_rows) {
    dat <- data.frame(t(dat))
    
  }
  
  if (!("sample" %in% colnames(dat))) {
    stop("You need a sample column in the OTU table")
  }
  
  if (is.null(metadata)) {
    meta <- data.frame(
      sample = dat$sample,
      place_holder = paste0("place_holder", 1:nrow(dat))
    )
  } else {
    meta <- read.csv(metadata, sep = "\t", header = T, na.strings = '')
  }
  
  if (!is.null(remove_metadata_vars)) {
    meta <- meta[, !str_detect(colnames(meta), remove_metadata_vars)]
  }
  colnames(meta) <- c("sample", colnames(meta)[2:ncol(meta)])
  
  if (meta_smpls_only) {
    dat <- dat %>% filter(sample %in% meta$sample)
    deleted_samples = dat$sample[!(dat$sample %in% meta$sample)]
    if (length(deleted_samples) > 0) {
      warning(str_glue('Deleted the following samples:\n{deleted_samples}'))
    }
  }
  if (!is.null(remove_samples)) {
    meta <- meta %>% filter(!(sample %in% remove_samples))
    dat <- dat %>% filter(!(sample %in% remove_samples))
  }
  
  if (!is.null(include_samples)) {
    meta <- meta %>% filter(sample %in% include_samples)
    dat <- dat %>% filter(sample %in% include_samples)   
  }
  
  if (plyr::empty(dat)) stop('Empty otu table. Do sample names match with those from metadata?')
  
  if (merge_dilutions) {
    message('Merging dilutions - considering only .1.1.1 samples for metadata.')
    dat <- dat %>%
      mutate(sample = str_extract(sample, '\\d+')) %>%
      group_by(sample) %>%
      summarise_each(~ sum(.)) %>%
      mutate(sample = paste0(sample, '.1.1.1')) %>%
      as.data.frame()
    meta <- meta %>%
      filter(endsWith(as.character(sample), '.1.1.1'))
  }
  
  rownames(dat) <- paste0("Smpl",  str_extract(dat$sample, "\\d+.*"))
  dat$sample <- NULL
  rownames(meta) <- paste0("Smpl", str_extract(meta$sample, "\\d+.*"))
  
  tax <- read.csv(taxtable, sep = "\t") %>%
    select(otu, kingdom, phylum, class, 
           order, family, genus, species) %>%
    filter(kingdom != "", kingdom != "0", kingdom != 0) %>%
    unique()
  rownames(tax) <- tax[,1]
  
  tax <- as.matrix(tax[,2:8])
  if (speciesonly) {
    tax <- tax %>% filter(species != "") %>% distinct() %>% as.matrix()
  }
  otustokeep <- rownames(tax)
  dat <- dat[,otustokeep]
  if (!is.null(treefile)) tree <- read_tree(treefile = treefile) %>% phy_tree()
  
  if (mean(rownames(dat) %in% rownames(meta)) < 1) {
    index = !(rownames(dat) %in% rownames(meta))
    not_in_meta = rownames(dat)[index]
    print(str_glue("Samples in otutable that are NOT in metadata: \n
                   {not_in_meta}"))
    stop("Not all samples in your otu table have corresponding metadata.")
  }
  if (mean(colnames(dat) %in% rownames(tax)) < 1) {
    index = !(colnames(dat) %in% rownames(tax))
    not_in_tax = colnames(dat)[index]
    message(paste("Tax in otu table, but NOT in tax table", not_in_tax, "\n"))
    stop("Not all taxa in otu table have a corresponding taxa table entry.")
  }
  if (mean(rownames(tax) %in% colnames(dat)) < 1) {
    index = !(rownames(tax) %in% colnames(dat))
    not_in_otu = rownames(tax)[index]
    message(paste("Tax in tax table, but NOT in otu table", not_in_otu, "\n"))
    stop("Not all taxa in tax table have a corresponding otu table column.")
  }
  if (!is.null(treefile)) {
    if (mean(taxa_names(tree) %in% rownames(tax)) < 1) {
      index = !(taxa_names(tree) %in% rownames(tax))
      not_in_tax = taxa_names(tree)[index]
      message(paste("In tree, but NOT in tax table:", not_in_tax, "\n"))
      stop("Not all taxa in tree have corresponding taxa lineage")
    }
    if (mean(rownames(tax) %in% taxa_names(tree)) < 1) {
      index = !(rownames(tax) %in% taxa_names(tree))
      not_in_tree = rownames(tax)[index]
      message(paste("In tax table, but NOT in tree:", not_in_tree, "\n"))
    }
  }
  
  if (is.null(treefile)) {
    phyl <- phyloseq(otu_table(dat, taxa_are_rows = FALSE),
                     sample_data(meta), 
                     tax_table(tax))
  } else {
    phyl <- phyloseq(otu_table(dat, taxa_are_rows = FALSE),
                     sample_data(meta), 
                     tax_table(tax), 
                     phy_tree(tree)) 
  }
  
  if (bacteria_only) {
    phyl <- subset_taxa(phyl, kingdom == "Bacteria")
  }
  
  
  if (mean(c("samples", "taxa") %in% remove_zeros) > 0 ) {
    if ("taxa" %in% remove_zeros) {
      phyl <- prune_taxa(taxa_sums(phyl) > 0 , phyl)
    }
    if ("samples" %in% remove_zeros) {
      phyl <- prune_samples(sample_sums(phyl) > 0 , phyl)
    }
    if (mean(taxa_sums(phyl) > 0) < 1) {
      message("Still got some zeroed taxa...")
    } 
    if (mean(sample_sums(phyl) > 0) < 1) {
      message("Still got some zeroed samples...")
    }
  }
  
  tax_table(phyl)[tax_table(phyl) == 0] = ""
  
  return(phyl)
}

tidy_phylo_data <- function(.phyloseq, all_ranks = FALSE) {
  #' Make a tidy tibble from phyloseq object.
  #'
  #' @description Extracts information from otu_table, sample_data, and tax_table into a
  #' tidy tibble. Optionally, it can include information of all ranks for each taxon.
  #' 
  #' @param .phyloseq A phyloseq object.
  #' @param all_ranks Logical.Pass to return full rank info for each bacteria.
  #' 
  #' @details Returns a tibble with columns "Sample" (sample_names), "bacteria" (taxa_names),
  #'  all metadata columns, and, optionally, all rank information for the respective bacteria.
  .meta_cols <- colnames(sample_data(.phyloseq))
  .dat <- data.frame(
    .phyloseq@otu_table@.Data,
    .phyloseq@sam_data,
    Sample = sample_names(physeq = .phyloseq),
    check.names = FALSE,
    stringsAsFactors = FALSE
  ) %>% 
    gather("bacteria", ".value", -c(.meta_cols, "Sample")) %>%
    as_tibble()
  if (all_ranks) {
    .tax <- data.frame(
      .phyloseq@tax_table@.Data,
      bacteria = as.character(taxa_names(.phyloseq)),
      stringsAsFactors = FALSE
    )
    .dat <- left_join(.dat, .tax, by = 'bacteria')
    
  }
  .dat <- .dat %>%
    select(Sample, bacteria, .value, 
           !!! syms(.meta_cols),
           everything()) %>%
    arrange(.value, bacteria, Sample)
  return(.dat)
}

compute_lowest <- function(.phyloseq) {
  #' Add lca column to tax_table of a phyloseq object
  #'
  #' @description Uses `tax_table`` info to construct addtional lca column
  #' corresponding to the assigned taxonomy at its lowest (non-empty) level.
  #'  
  #' @param .phyloseq A phyloseq object.
  #' 
  #' @details Returns a phyloseq object with additional lowest_taxonomy and lowest_rank columns in the `tax_table` slot.
  #' The lowest_taxonomy column is assumed to be the lowest non-empty taxonomy assigned to each oligotype. 
  
  tax <- .phyloseq@tax_table@.Data
  lowest_rank <- data.frame(tax) %>% 
    mutate(
      lowest_rank = case_when(
        species != "" ~ "species",
        genus != "" ~ "genus",
        family != "" ~ "family",
        order != "" ~ "order",
        class != "" ~ "class",
        phylum != "" ~ "phylum",
        kingdom != "" ~ "kingdom",
        TRUE ~ ""
      )
    ) %>% pull(lowest_rank)
  l = list(rownames(tax), lowest_rank)
  lowest_taxonomy <- pmap_chr(l, function(oligo, lrank) tax[oligo, lrank])
  
  tax_table(.phyloseq) <- tax_table(cbind(lowest_rank, tax, lowest_taxonomy))
  return(.phyloseq)
}

tax_glom2 <- function(.phyloseq, .rank) {
  
  if (.rank == "oligotype") {
    return(.phyloseq)
  }
  
  if (.rank  %in% c("lowest", "lowest_taxonomy", "lowest_rank")) {
    .rank <- "lowest_taxonomy"
  }
  
  if (.rank == "lowest_taxonomy" & !("lowest_taxonomy" %in% rank_names(.phyloseq))) {
    .phyloseq <- compute_lowest(.phyloseq = .phyloseq)
  }
  
  .phyloseq <- tax_glom(
    physeq = .phyloseq,
    taxrank = .rank, 
    bad_empty = c(NA, "NA", "", "", "\t", 0, "0")
  )
  
  tax <- .phyloseq@tax_table@.Data
  duplicated_taxa <- table(tax[, .rank]) > 1
  duplicated_taxa_names <- names(duplicated_taxa)[duplicated_taxa]
  ix_duplicated_taxa <- which(tax[,.rank] %in% duplicated_taxa_names)
  
  if (.rank == "lowest_taxonomy") {
    new_names <- paste0(tax[ix_duplicated_taxa, .rank],
                        " (",
                        tax[ix_duplicated_taxa, 'lowest_rank'],
                        ")"
    ) %>% 
      make.unique()
  } else {
    new_names <- make.unique(tax[ix_duplicated_taxa, .rank])
  }
  
  tax[ix_duplicated_taxa, .rank] <- new_names
  
  tax_table(.phyloseq) <- tax
  taxa_names(.phyloseq) <- tax_table(.phyloseq)[, .rank]    
  
  return(.phyloseq)
  
}

check_dir <- function(.path) {
  #' Make sure directory exists
  #'
  #' @description Create directory if it does not exist already (analogous to `mkdir -p`).
  #'  
  #' @param .path Path of directory to create.
  #' 
  #' @details If directory given by `.path` does not exist, it creates it with
  #' recursivity, i.e., analogously to `mkdir -p .path` in bash.
  
  if (!dir.exists(.path)) dir.create(.path, recursive = TRUE)
} 


scientific_10 <- function(x) {
  parse(text=gsub("e[\\+]*", "0^", scales::scientific_format()(x)))
}


make_color_maker <- function(x) {
  grDevices::colorRampPalette(x)
}

lm_phyloseq <- function(.phyloseq, .formula, .random, contrasts_list, 
                        only_signif=TRUE, get_fit=FALSE, .log=FALSE) {
  
  library(limma)
  
  design <- model.matrix(.formula, data = data.frame(.phyloseq@sam_data))
  
  otu <- otu_table(.phyloseq)@.Data
  if (isTRUE(.log)) {
    otu <- log10(otu + 1)
  }
  if (!taxa_are_rows(.phyloseq)) {otu <- t(otu)}
  
  if (!is.null(.random)) {
    design_random <- get_variable(.phyloseq, .random)
    correlations <- duplicateCorrelation(object = otu,
                                         design = design,
                                         block = design_random)
    fit <- otu %>% 
      voom(design = design, block = design_random, 
           correlation = correlations$consensus.correlation) %>% 
      lmFit(design = design, block = design_random,
            correlation = correlations$consensus.correlation)
  } else {
    fit <- otu %>% 
      voom(design = design) %>% 
      lmFit(design = design)
  }
  
  if (isTRUE(get_fit)) {
    return(eBayes(fit))
  }
  
  results <- contrasts_list %>% 
    map(~ fit %>% 
          contrasts.fit(contrasts = .x) %>% 
          eBayes() %>% 
          topTable(confint = TRUE) %>% 
          data.frame(bacteria = rownames(.), check.names = F) %>% 
          rename(.lower := `CI.L`, 
                 .upper := `CI.R`)
    )
  
  if (isTRUE(only_signif)) {
    results <- results %>% 
      map(~ .x %>% filter(adj.P.Val <= 0.05))
  }
  
  return(results)
  
}
