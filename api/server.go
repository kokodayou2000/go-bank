package api

import (
	"github.com/gin-gonic/gin"
	db "github.com/kokodayou2000/go-bank/db/sqlc"
)

type Server struct {
	store  *db.Store
	router *gin.Engine
}

func NewServer(store *db.Store) *Server {
	server := &Server{store: store}
	router := gin.Default()
	// get
	router.GET("/accounts/get/:id", server.getAccount)
	router.GET("/accounts/getList", server.listAccount)
	// delete
	router.DELETE("/accounts/delete/:id", server.deleteAccount)
	// create
	router.POST("/accounts/create", server.createAccount)
	// update
	router.POST("/accounts/update", server.updateAccount)
	server.router = router
	return server
}
func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}
