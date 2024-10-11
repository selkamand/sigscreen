library(sigstash)

a=Filter(x = sig_available()[[1]], f = \(x){ grepl(x = x, pattern = "3.4") })
for (d in a){ sig_load(d) |> sig_write_signatures(format = "csv_tidy", filepath = paste0("testdata/signature_collections/", d, ".tidy.csv"))}
