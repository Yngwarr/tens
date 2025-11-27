const LOCALIZATION_PATH = "../locales/Tens_locales.csv";
const SPREADSHEET_KEY = "1a_SriCqe845x9qYYXC5fyJE2kOgw1-8XGCyNRaEpi9w";

async function fetchSheet(key: string) {
	const response = await fetch(
		`https://docs.google.com/spreadsheets/d/${key}/gviz/tq?tqx=out:csv`,
	);

	if (!response.ok) {
		throw new Error(
			`Error while downloading the file, status: ${response.status} ${response.statusText}`,
		);
	}

	return await response.text();
}

async function downloadLocalization() {
	const sheetText = await fetchSheet(SPREADSHEET_KEY);
	Bun.write(LOCALIZATION_PATH, sheetText);
}

async function main() {
	try {
		await downloadLocalization();
		console.log("fresh localization straight from the oven!");
	} catch (e) {
		console.error(
			"Caught an error when downloading localization, now bailing...",
		);
		throw e;
	}
}

await main();
