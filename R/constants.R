# all the constants used by this package

.onLoad <- function(libname, pkgname) {
  
  bar_per_atm <- 1.01325
  
  # constants
  opts <- list(
    # base units
    base_units = c(
      "quantity" = NA_character_,
      "amount" = "mol",
      "mass" = "g",
      "molecular_weight" = "g/mol",
      "molarity_concentration" = "M",
      "mass_concentration" = "g/L",
      "volume" = "L",
      "pressure" = "bar",
      "gas_solubility" = "M/bar",
      "temperature" = "K"
    ),
    
    # abbreviation
    abbreviations = c(
      "quantity" = "qty",
      "amount" = "N",
      "mass" = "m",
      "molecular_weight" = "MW",
      "molarity_concentration" = "C",
      "mass_concentration" = "C",
      "volume" = "V",
      "pressure" = "P",
      "gas_solubility" = "S",
      "temperature" = "T"
    ),
    
    # metric prefixes
    metric_prefix = 
      rlang::set_names(
        c(1e-15, 1e-12, 1e-9, 1e-6, 1e-3, 1, 1e3, 1e6, 1e9, 1e12),
        c("f", "p", "n", stringi::stri_encode("\U00B5"), "m", "", "k", "M", "G", "T")
      ),
    
    # pressure units
    bar_per_pa = 1e-5,
    bar_per_atm = bar_per_atm,
    bar_per_psi = 1/14.50377,
    bar_per_Torr = 1/760 * bar_per_atm,
    
    # temperature units
    celsius_kelvin_offset = -273.15,
    fahrenheit_celsius_offset = 32,
    fahrenheit_celsius_slope = 9/5,
    
    # physical constants
    R_in_L_bar_per_K_mol = 0.08314462 # ideal gas constant in the units used as base units by microbialkitchen (L bar K-1 mol-1)
  )
  names(opts) <- paste0("microbialkitchen_", names(opts))
  options(opts)
}

#' Constants
#' 
#' List and retrieve constants used in microbialkitchen.
#' 
#' @name constants
NULL 
 
#' @describeIn constants get the value of a constant
#' @param name name of the constant
#' @export
get_microbialkitchen_constant <- function(name) {
  value <- getOption(paste0("microbialkitchen_", name))
  if (is.null(value)) stop("constant ", name, " is not specified")
  return(value)
}

#' @describeIn constants list all constants
#' @export
get_microbialkitchen_constants <- function() {
  opts <- options() %>% {.[names(.) %>% stringr::str_detect("^microbialkitchen_")]}
  tibble(
    constant = names(opts) %>% stringr::str_replace("^microbialkitchen_", ""),
    key = purrr::map(opts, names) %>% purrr::map( ~ if (is.null(.x)) { NA_character_ } else { .x }),
    value = purrr::map(opts, identity)
  ) %>% tidyr::unnest(.data$key, .data$value)
}
