#' Create and upload data into a table in slides
#' @description This operation can only occur one at a time
#' @inheritParams build_create_table
#' @inheritParams dataframe_convert
#' @inheritParams post_batchUpdate
#' @param id ID of the presentation slide
#' @export
create_data_table <- function(id=NULL, pageElementProperty=NULL, data=NULL, headers=TRUE){
  # First create the table to get the objectId
  rows <- nrow(data)
  if(headers){
    rows <- rows + 1
  }
  columns <- ncol(data)
  requests_list <- build_create_table(pageElementProperty[[1]], rows, columns)
  result_list <- post_batchUpdate(id, requests_list)
  # Get the object id
  objectId <- result_list$replies$createTable$objectId
  # Create the list to send to update the table
  converted_data <- dataframe_convert(data, headers)
  requests_list <- build_insert_text(rep(objectId, rows * columns), rowIndex = converted_data$row,
                                     columnIndex = converted_data$column,
                                     text = converted_data$value)
  result_list <- post_batchUpdate(id, requests_list)
  return(result_list)
}
