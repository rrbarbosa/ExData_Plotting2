# Get the dataset
if (!file.exists('exdata2.zip')) {
	download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "exdata2.zip", "curl")
}

# extract contents
unzip("exdata2.zip")
