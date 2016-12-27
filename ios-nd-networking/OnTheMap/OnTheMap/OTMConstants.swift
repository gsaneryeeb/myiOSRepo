//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by JasonZhang on 20/12/2016.
//  Copyright © 2016 Saneryee. All rights reserved.
//

// MARK: - OTMClient (Constants)

extension OTMClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        
        // Parse Application ID:QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr
        // REST API Key:QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY
        
        static let ApiKey = "Udacity-API-KEY"
        
        // MARK: URLs For Udacity
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        
        static let AuthorizationURL = "https://www.themoviedb.org/authenticate/"
        static let AccountURL = "https://www.themoviedb.org/account/"
    }
    
    // MARK: Methods
    struct Methods {
        
        
        // MARK: Session for Udacity
        static let Session = "/session"
        
        // MARK: Users for Udacity
        static let Users = "/users"
        
        // MARK: Account
        static let Account = "/account"
        static let AccountIDFavoriteMovies = "/account/{id}/favorite/movies"
        static let AccountIDFavorite = "/account/{id}/favorite"
        static let AccountIDWatchlistMovies = "/account/{id}/watchlist/movies"
        static let AccountIDWatchlist = "/account/{id}/watchlist"
        
        // MARK: Authentication
        static let AuthenticationTokenNew = "/authentication/token/new"
        static let AuthenticationSessionNew = "/authentication/session/new"
        
        // MARK: Search
        static let SearchMovie = "/search/movie"
        
        // MARK: Config
        static let Config = "/configuration"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Users for Udacity
        static let Account = "account"
        static let UserKey = "key"
        static let Status = "status"
        static let Session = "session"
        static let Error = "error"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // MARK: Movies
        static let MovieID = "id"
        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        
    }
    
    // MARK: Poster Sizes
    struct PosterSizes {
        static let RowPoster = OTMClient.sharedInstance().config.posterSizes[2]
        static let DetailPoster = OTMClient.sharedInstance().config.posterSizes[4]
    }
}
