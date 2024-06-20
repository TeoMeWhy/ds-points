package db

import (
	"database/sql"

	_ "github.com/mattn/go-sqlite3"
)

func Connect() (*sql.DB, error) {

	con, err := sql.Open("sqlite3", "../../data/feature_store.db")
	if err != nil {
		return nil, err
	}

	return con, nil

}

func GetUser(id string, con *sql.DB) (map[string]string, error) {

	query := `
	SELECT 
		dtRef AS dtRef,
		idCustomer AS idCustomer,
		prob_churn AS probChurn,
		cluster_recencia AS cicloVida,
		cluster_fv AS clusterRF,
		dtUpdate AS dtUpdate

	FROM customer_profile

	WHERE idCustomer = ?
	AND dtRef = (SELECT MAX(dtRef) FROM customer_profile)
	`

	state, err := con.Prepare(query)
	if err != nil {
		return nil, err
	}

	rows, err := state.Query(id)
	if err != nil {
		return nil, err
	}

	var dtRef, idCustomer, probChurn, cicloVida, clusterRF, dtUpdate string
	for rows.Next() {
		rows.Scan(&dtRef, &idCustomer, &probChurn, &cicloVida, &clusterRF, &dtUpdate)
	}

	values := map[string]string{
		"dtRef":      dtRef,
		"idCustomer": idCustomer,
		"probChurn":  probChurn,
		"cicloVida":  cicloVida,
		"clusterRF":  clusterRF,
		"dtUpdate":   dtUpdate,
	}

	return values, nil
}
