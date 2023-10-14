{
  require(dplyr)
  require(readr)
  require(readxl)
  require(bdc)
  require(rWCVP)
  # citation("rWCVP")
}

setwd("C:/Users/santi/OneDrive/Meliponini Mestrado/Desenvolvimento/04_Polinizacao de culturas")
db <- readxl::read_xlsx("BD polinizadores.xlsx", 1)

clean_sp_names <- bdc::bdc_clean_names(db$Vegetal)
db$Vegetal <- clean_sp_names$scientificName
clean_sp_names <- bdc::bdc_clean_names(db$Polinizador)
db$Polinizador <- clean_sp_names$scientificName
unique(db$Polinizador)
unique(db$Vegetal)


##%######################################################%##
#                                                          #
####       Harmonization of plant speceis names         ####
#                                                          #
##%######################################################%##
bin_names <- function(d, column) {
  d <- d %>%
    dplyr::pull(column) %>%
    stringr::str_split_fixed(., " ", 3)
  if (any(d[, 2] == "×")) {
    filt <- which(d[, 2] == "×")
    d[filt, 2] <- paste(d[filt, 2], d[filt, 3])
    d[filt, 2] <- gsub("×", "x", d[filt, 2])
  }
  if (any(d[, 2] == "x")) {
    filt <- which(d[, 2] == "x")
    d[filt, 2] <- paste(d[filt, 2], d[filt, 3])
  }
  d <- paste(d[, 1], d[, 2])
  d <- stringr::str_trim(d)
  return(d)
}

plant_sp <- data.frame(species= db$Vegetal %>% unique() %>% sort()) %>% as_tibble()

names_db <- rWCVPdata::wcvp_names

# read plant names database
db2 <- wcvp_match_names(plant_sp,
                        name_col = "species",
                        fuzzy = TRUE,
                        progress_bar = TRUE
)

# ✔ Matched 622 of  names
# ℹ Exact (without author): 585
# ℹ Fuzzy (edit distance): 22
# ℹ Fuzzy (phonetic): 15
# ! Names with multiple matches: 49

db2$wcvp_status %>%
  unique() %>%
  sort()
db3 <- db2 %>% dplyr::filter(wcvp_status %in% c("Synonym", "Accepted"))
nrow(plant_sp)
nrow(db3)

# Duplicated names
spp <- db3 %>%
  dplyr::filter(duplicated(species)) %>%
  pull(species)
spp

db3 <- bind_rows(
  db3 %>% dplyr::filter(!species %in% spp) %>%
    dplyr::filter(wcvp_status == "Accepted"),
  db3 %>%
    dplyr::filter(species %in% spp) %>%
    dplyr::filter(wcvp_status == "Accepted")
)

nrow(plant_sp) - nrow(db3)

# check some species
db2[!db2$species %in% db3$species, ] %>% View()

# Add accepted names to all names
db3 <- db3 %>%
  dplyr::select(
    species, wcvp_status,
    wcvp_name, wcvp_authors, match_type, wcvp_accepted_id
  ) %>%
  dplyr::mutate(final_wcvp_accepted_name = wcvp_name)
db3


# Illegitimate or Invalid names
db2$wcvp_status %>% unique()
filt_a <- db2 %>% # codes for updating
  dplyr::filter(wcvp_status %in% c("Invalid", "Illegitimate"), !multiple_matches) %>%
  pull(wcvp_accepted_id)

# Synonyms
filt_b <- db3 %>%
  dplyr::filter(wcvp_status %in% c("Synonym")) %>%
  pull(wcvp_accepted_id)

# final filt
filt <- names_db %>%
  dplyr::filter(plant_name_id %in% c(filt_a, filt_b)) %>%
  dplyr::select(accepted_plant_name_id, taxon_name, wcvp_authors = taxon_authors) %>%
  dplyr::arrange(accepted_plant_name_id)

# replace names in final_wcvp_accepted_name
for (i in 1:nrow(filt)) {
  db3[which(db3$wcvp_accepted_id == filt$accepted_plant_name_id[i]), "final_wcvp_accepted_name"] <- filt$taxon_name[i]
  db3[which(db3$wcvp_accepted_id == filt$accepted_plant_name_id[i]), "wcvp_authors"] <- filt$wcvp_authors[i]
}

# remove intraspecific names
db3 <- db3 %>% dplyr::mutate(final_wcvp_accepted_name = bin_names(db3, column = "final_wcvp_accepted_name"))
db3$final_wcvp_accepted_name %>% unique()

# Update id
i <- 1
for (i in 1:nrow(db3)) {
  message(i)
  tryCatch(
    expr = {
      if (grepl(" x ", db3$final_wcvp_accepted_name[i])) {
        db3$wcvp_accepted_id[i] <- names_db %>%
          dplyr::filter(taxon_name == gsub(" x ", " × ", db3$final_wcvp_accepted_name[i])) %>%
          dplyr::filter(taxon_status == "Accepted") %>%
          dplyr::pull(accepted_plant_name_id)
      } else {
        db3$wcvp_accepted_id[i] <- names_db %>%
          dplyr::filter(taxon_name == db3$final_wcvp_accepted_name[i]) %>%
          dplyr::filter(taxon_status == "Accepted") %>%
          dplyr::pull(accepted_plant_name_id)
      }
    },
    error = function(e) {
      message("Species not found")
    }
  )
}


# Problematic species
plant_sp %>% dim()
db3 %>% dim()
sppp <- plant_sp[!plant_sp$species %in% db3$species, ] %>% pull(species)
length(sppp)

sppp <- db2[db2$species %in% sppp, ] %>% dplyr::select(
  final_wcvp_accepted_name = wcvp_name, wcvp_id, wcvp_accepted_id,
  wcvp_authors,
  species, wcvp_status
)
sppp <- sppp %>% arrange(species)

sppp$species
sppp$wcvp_status %>% unique()

for (i in 1:nrow(sppp)) {
  if (!is.na(sppp$wcvp_accepted_id[i])) {
    sppp[i, c("final_wcvp_accepted_name", "wcvp_authors")] <-
      names_db %>%
        dplyr::filter(accepted_plant_name_id == sppp$wcvp_accepted_id[i], taxon_status == "Accepted") %>%
        dplyr::filter(taxon_status == "Accepted") %>%
        dplyr::select(taxon_name, taxon_authors)
  }
}

# Add names not found as accepted names
# sppp$final_wcvp_accepted_name[is.na(sppp$final_wcvp_accepted_name)] <-
# sppp$species[is.na(sppp$final_wcvp_accepted_name)]

sppp <- sppp %>%
  mutate(final_wcvp_accepted_name = bin_names(sppp, column = "final_wcvp_accepted_name"))


db3 <- db3 %>%
  dplyr::select(
    final_wcvp_accepted_name, wcvp_accepted_id,
    wcvp_authors,
    species, wcvp_status
  )
sppp <- sppp %>%
  dplyr::select(
    final_wcvp_accepted_name, wcvp_accepted_id,
    wcvp_authors,
    species, wcvp_status
  ) # %>% dplyr::filter(!duplicated(final_wcvp_accepted_name))
# Remove illegitimal names
sppp <- sppp %>% dplyr::filter(wcvp_status == "Synonym")

sppp[sppp$species == "Solanum inaequale" & sppp$wcvp_authors != c("A.St.-Hil."), ]
sppp <- sppp[which(!(sppp$species == "Solanum inaequale" & sppp$wcvp_authors != c("A.St.-Hil.")))
  , ]

sppp <- sppp[which(!(sppp$species == "Tradescantia purpurea" & sppp$wcvp_authors!="wcvp_authors")), ]

asdf <- as.data.frame(sppp[1, ])
asdf[1,] <- c("Tradescantia pallida", NA, "(Rose) D.R.Hunt", "Tradescantia purpurea", "Synonym")
asdf$wcvp_accepted_id <- NA
sppp <- bind_rows(sppp, asdf)
sppp <- unique(sppp)


db3 <- bind_rows(db3, sppp)
db3 <- unique(db3)
nrow(db3)
nrow(plant_sp)

# readr::write_tsv(db3, "taxonomic_correction.txt")

# Merge with original databaes

db <- readxl::read_xlsx("BD polinizadores.xlsx", 1)
db <- left_join(db, db3, by =c("Vegetal" = "species"))
db <- janitor::clean_names(db)
# readr::write_tsv(db, "BD polinizadores_plant_names_corrected.txt")

##%######################################################%##
#                                                          #
####                Find uses for plant                 ####
####      species based on GlobalUsefulNativeTrees      ####
#                                                          #
##%######################################################%##
db <- readr::read_tsv("BD polinizadores_plant_names_corrected.txt")
plant_sp <- db %>% dplyr::select(vegetal, final_wcvp_accepted_name) %>% unique

# readr::write_tsv(plant_sp, "original_and_corrected_plant_names.txt")
