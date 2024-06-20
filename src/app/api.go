package main

import (
	"app/db"
	"net/http"

	"github.com/gin-gonic/gin"
)

var con, _ = db.Connect()

func getUserProfile(c *gin.Context) {
	id := c.Param("id")

	profile, err := db.GetUser(id, con)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "erro interno na busca pelo usuário"})
		return
	}

	if profile["idCustomer"] == "" {
		c.JSON(http.StatusNotFound, gin.H{"error": "usuário não encontrado"})
		return
	}

	c.JSON(http.StatusOK, profile)

}

func main() {

	router := gin.Default()

	router.GET("/profile/:id", func(c *gin.Context) {
		getUserProfile(c)
	})

	router.Run("localhost:8082")
}
