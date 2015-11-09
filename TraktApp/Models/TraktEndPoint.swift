//
//  TraktEndPoint.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 08/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//
import Foundation

struct TraktEndPoint {
    
    static let usersSettings = users.settings
    /**
     *  Users End Points.
     */
    struct users {
        /**
         *  The authenticated user's settings.
         *  - Note: Possible HTTP methods: ``GET``.
         *  - SeeAlso: (http://docs.trakt.apiary.io/#reference/users/settings/approve-follow-request)
         */
        static let settings = "users/settings"
        /**
         *  A user's pending follow requests.
         *  - Note: Possible HTTP methods: ``GET``, ``POST``, ``DELETE``.
         *  - Note: Approve a follower using the id of the request. If the id is not found, was already approved, or was already denied, a 404 error will be returned. To deny a follower, use the same approach but use ``DELETE``, instead of ``POST`` method for the request.
         *  - SeeAlso: [Trakt.tv API documentation](http://docs.trakt.apiary.io/#reference/users/approve-or-deny-follower-requests/approve-follow-request)
         */
        static let requests = "users/requests"
        /**
         *  Get hidden items for a section. This will return an array of standard media objects.
         *  - Note: Possible HTTP methods: ``GET``.
         *  - Note: You can optionally limit the type of results to return by appending the end point.
         *  - SeeAlso: [Trakt.tv API documentation](http://docs.trakt.apiary.io/#reference/users/hidden-items/get-hidden-items)
         */
        static let hidden = "users/hidden"
        /**
         *  Get items a user likes. This will return an array of standard media objects.
         *  - Note: You can optionally limit the type of results to return.
         *  - Note: Possible HTTP methods: ``GET``.
         *  - SeeAlso: [Trakt.tv API documentation](http://docs.trakt.apiary.io/#reference/users/likes/get-likes)
         */
        static let likes = "users/likes"
        /**
         *  Get the authenticated user's profile information.
         *  - Note: Possible HTTP methods: ``GET``.
         *  - SeeAlso: [Trakt.tv API documentation](http://docs.trakt.apiary.io/#reference/users/profile/get-user-profile)
         */
        static let profile = "users/me"
        /**
         *  Get all collected items in the authenticated user's collection. A collected item indicates availability to watch digitally or on physical media.
         *  - Note: If you add ?extended=metadata to the URL, it will return the additional media_type, resolution, audio, audio_channels and '3d' metadata. It will use null if the metadata isn't set for an item.
         *  - Note: Possible HTTP methods: ``GET``.
         *  - SeeAlso: [Trakt.tv API documentation](http://docs.trakt.apiary.io/#reference/users/collection/get-collection)
         */
        static let collection = "users/me/collection"
        /**
         *  Returns comments the user has posted sorted by most recent.
         *  - Note: Add the optional parameter *comment_type* to the query string to retrieve a specific kind. Possible values are ``all``, ``reviews`` and ``shouts``.
         *  - Note: Add the optional parameter *type* to the query string to retrieve comments made on a specific kind of medium. Possible values are ``all``, ``movies``, ``shows``, ``seasons``, ``episodes`` and ``lists``.
         *  - Note: Possible HTTP methods: ``GET``.
         *  - SeeAlso: [Trakt.tv API documentation](http://docs.trakt.apiary.io/#reference/users/comments/get-comments)
         */
        static let comments = "users/me/comments"
        /**
         *  Returns all custom lists for the user. Same end point is used to create, update or delete a custom list.
         *  - Note: Add ``:id/items`` to get the actual items a specific list contains.
         *  - Note: To create a custom list, the HTTP method to use must be ``POST``. The JSON post data must also include the field *name* with value type string. Other possible keys are *description* (value type string), *display_numbers* (value type boolean) with false as default determining whether the items should be numbered, *allow_comments* (value type boolean) with value true as default determining if comments are allowed.
         *  - Note: A custom list is by default private. To set a different privacy type on creation, add the key *privacy* in the post fields. Possible values are ``private``, ``friends`` or ``public``.
         *  - Note: To update a custom list, the list id must be added to the query string. Update requires the same JSON post data fields as the create method.
         *  - Note: Possible HTTP methods: ``GET``, ``POST`` or ``DELETE``.
         *  - SeeAlso: [Trakt.tv API documentation](http://docs.trakt.apiary.io/#reference/users/lists/get-a-user's-custom-lists)
         */
        static let lists = "users/me/lists"
        /**
         *  Like or unlike a user's list.
         *  - Note: Possible HTTP methods: ``POST``, ``DELETE``.
         *  - SeeAlso: [Trakt.tv API documentation](http://docs.trakt.apiary.io/#reference/users/list-like/like-a-list)
         */
        static func list(likeListWithName id: String, ofUser user: String) -> String {
            return "users/\(user)/lists/\(id)/like"
        }
        /**
         *  Like or unlike a user's list.
         *  - Note: Possible HTTP methods: ``POST``, ``DELETE``.
         *  - SeeAlso: [Trakt.tv API documentation](http://docs.trakt.apiary.io/#reference/users/list-like/like-a-list)
         */
        static func list(unlikeListWithName id: String, ofUser user: String) -> String {
            return self.list(likeListWithName: id, ofUser: user)
        }
        /**
         *  Returns all items in a user's watchlist filtered by type. When an item is watched, it will be automatically removed from the watchlist.
         *  - Note: Limit return data by specifying a ``type``, using the method watchlist(withType:). Possible values are ``movies``, ``shows``, ``seasons`` or ``episodes``.
         *  - Note: Possible HTTP methods: ``GET``.
         *  - SeeAlso: [Trakt.tv API documentation](http://docs.trakt.apiary.io/#reference/users/watchlist/get-watchlist)
         */
        static let watchlist = "users/me/watchlist/"
    }
    
}