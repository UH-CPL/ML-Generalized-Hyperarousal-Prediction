code_dir <- 'code'
data_dir <- 'data'
figure_dir <- 'figure'


sim1_study <- 'sim1'
sim2_study <- 'sim2'
tt1_study <- 'tt1'
email_stress_study <- 'office_task_study'
all_studies <- 'all_studies'


default_plot_width <- 12
default_plot_height <- 10


decorator_hash <- '###########################################################'



# one_hour_sec <- 3600
# session_list <- c('Baseline', 'WorkingSession')
# pp_file_pattern <- '.*_pp.csv'
# s_interface_date_format <- '%a %b %d %H:%M:%S %Y'
# qc1_filtered_data_file_name <- 'qc1_bad_filtered_data.csv'




#------------------------------------#
#-------   Common Functions   -------#
#------------------------------------#
custom_read_csv <- function(file_name) {
  return(read.csv(file_name, stringsAsFactors=F))
}

convert_to_csv <- function(df, file_path) {
  write.table(df, file = file_path, row.names=F, sep = ',')
}

save_plot <- function(plot_name, plot, width=default_plot_width, height=default_plot_height) {
  plot_path <- file.path(all_studies_figure_dir, paste0(plot_name, '.png'))
  ggsave(plot_path, plot, width=width, height=height)
  
  plot_path <- file.path(all_studies_figure_dir, paste0(plot_name, '.pdf'))
  ggsave(plot_path, plot, device=cairo_pdf, width=width, height=height)
}

save_rmd_plot <- function(plot_name, plot, width=default_plot_width, height=default_plot_height) {
  plot_path <- file.path(project_dir, plots_dir, paste0(plot_name, '.png'))
  ggsave(plot_path, plot, width=width, height=height)
  
  plot_path <- file.path(project_dir, plots_dir, paste0(plot_name, '.pdf'))
  ggsave(plot_path, plot, device=cairo_pdf, width=width, height=height)
}



#--------------------------#
#-------   String   -------#
#--------------------------#
print_msg <- function(msg) {
  print(msg)
  message(msg)
}

write_log_msg <- function(msg, file_name) {
  print_msg(msg)
  write(msg, file=file_name, append=TRUE)
}

is_match <- function(str, pattern) { 
  return(grepl(pattern, str)) 
} 

replace_to_underscore <- function(str) {
  gsubfn('.', list('.' = '_', ' ' = '_', '-' = '_'), tolower(str))
}

replace_to_space <- function(str) {
  gsubfn('.', list('_' = ' ', '-' = ' '), str)
}

remove_rigth_substr <- function(str, n){
  substr(str, 1, nchar(str)-n)
}

get_right_substr <- function(str, n){
  substr(str, nchar(str)-n+1, nchar(str))
}

trim <- function( x ) {
  gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)
}

specify_decimal <- function(x, k) {
  trimws(format(round(x, k), nsmall=k))
}

is_null <- function(cell_val) {
  # print(cell_val)
  if (length(trim(cell_val))==0) {
    return(T)
  } else if (is.na(cell_val)) {
    return(T)
  } else if (cell_val=='NA') {
    return(T)
  }
  
  # else if (cell_val=="") {
  #   return(T)
  # }
  
  return(F)
}

#---------------------------------#
#-------   Date and Time   -------#
#---------------------------------#
convert_date <- function(date, date_format) {
  return(as.POSIXct(date, format=date_format))
}

convert_s_interface_date <- function(date) {
  convert_date(date, s_interface_date_format)
  # convert_date(paste0(substr(date, 1, 19), substr(date, 24, 29)), s_interface_date_format)
}

convert_marker_date <- function(date) {
  return(paste0(substr(date, 1, 19), substr(date, 24, 29)))
}


#--------------------------#
#--- File and Directory ---#
#--------------------------#
is_empty <- function(item) {
  return(length(item)==0)
}

get_dir_list <- function(directory) {
  return(list.dirs(path=directory, full.names=F, recursive=F))
}

get_matched_file_names <- function(directory, file_pattern) {
  return(list.files(path=directory, pattern=file_pattern, recursive=F))
}

get_matched_file_names_recursively <- function(directory, file_pattern) {
  return(list.files(path=directory, pattern=file_pattern, recursive=T))
}


#-----------------------------#
#--- Plot Helper Functions ---#
#-----------------------------#
get_n <- function(x) { 
  return(c(y=-Inf, vjust = -1, label=length(x))) 
} 



get_significance_sign <- function(p_value) { 
  if (p_value > 0.05) { 
    return(" ") 
  } else if (p_value <= 0.001) { 
    return("***") 
  } else if (p_value <= 0.01) { 
    return("**") 
  } else if (p_value <= 0.05) { 
    return("*") 
  } 
}

get_gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}





# 
# #-----------------------------#
# #--- Deadline Stress Study ---#
# #-----------------------------#
# get_shift_val <- function(df, signal) {
#   shift_val <- 0 
#   
#   if (min(df[[signal]], na.rm = TRUE) <= 0) {
#     shift_val <- abs(min(df[[signal]], na.rm = TRUE)) + delta_shift_val
#   }
#   
#   # print(paste0(signal, ' - ', shift_val))
#   shift_val
# }
# 
# 
# 
# 
# generate_daywise_mean_data <- function(mean_df, output_v2_file_name) {
#   daywise_mean_df <- mean_df %>%
#     gather(Signal, Mean_Value, -Participant_ID, -Day, -Treatment) %>% 
#     spread(Day, Mean_Value) %>%
#     mutate(Day3_Day4_Mean = case_when(
#       !is.na(Day3) & !is.na(Day4)~(Day3+Day4)/2,
#       !is.na(Day3)~Day3,
#       !is.na(Day4)~Day4,
#       TRUE~Day3)) %>%  # it's creating problem for NA. Anyhow Day3 or Day4 is NA, so default NA
#     mutate(Day3_Day4_Min = pmin(Day3, Day4, na.rm = TRUE)) %>% 
#     mutate(Four_Day_Min = pmin(Day1, Day2, Day3, Day4, na.rm = TRUE))
#   
#   if (t_test_comparison==day3_day4_ws_mean) {
#     daywise_mean_df <- daywise_mean_df %>%
#       mutate(Day1_Normalize=Day1-Day3_Day4_Mean,
#              Day2_Normalize=Day2-Day3_Day4_Mean)
#     
#   } else if (t_test_comparison==day3_day4_ws_min) {
#     daywise_mean_df <- daywise_mean_df %>%
#       mutate(Day1_Normalize=Day1-Day3_Day4_Min,
#              Day2_Normalize=Day2-Day3_Day4_Min)
#   }
#   
#   convert_to_csv(daywise_mean_df, file.path(project_dir, curated_data_dir, physiological_data_dir, output_v2_file_name))
# }
# 
# generate_treatment_mean_data <- function(df) {
#   mean_df <- df %>%
#     dplyr::select(Participant_ID,	Day, Treatment, Mask, PP, E4_HR, E4_EDA, iWatch_HR) %>%
#     group_by(Participant_ID,	Day, Treatment) %>%
#     filter(Mask==1) %>%
#     summarize_all(mean, na.rm=T) %>%
#     ungroup() %>% 
#     dplyr::select(-Mask)
#   
#   return(mean_df)
# }
# 
# 
# generate_mean_data <- function(input_file_name, output_v1_file_name, output_v2_file_name) {
#   physiological_data_dir_path <- file.path(project_dir, curated_data_dir, physiological_data_dir)
#   
#   df <- custom_read_csv(file.path(physiological_data_dir_path, input_file_name))
#   mean_df <- generate_treatment_mean_data(df)
#   convert_to_csv(mean_df, file.path(physiological_data_dir_path, output_v1_file_name))
#   
#   generate_daywise_mean_data(mean_df, output_v2_file_name)
# }







