struct Game: Decodable {
    let id: Int
    let ageRatings: [AgeRating]
    let genres: [Genre]
    let involvedCompanies: [InvolvedCompany]
    let name: String
    let rating: Double
    let releaseDates: [ReleaseDate]
    let screenshots: [Screenshot]
    let summary: String
}

/*
 https://api.igdb.com/v4/games/?fields=id,name,rating,screenshots.image_id,genres.name,age_ratings.rating_cover_url,involved_companies.company.name,summary,release_dates.y%3B&limit=10&where=screenshots.image_id!%3DNULL
 */

/*
 {
       "id":2563,
       "age_ratings":[
          11331,
          11332,
          105666,
          105667,
          105668
       ],
       "cover":{
          "id":178612,
          "alpha_channel":false,
          "animated":false,
          "game":2563,
          "height":800,
          "image_id":"co3ttg",
          "url":"//images.igdb.com/igdb/image/upload/t_thumb/co3ttg.jpg",
          "width":600,
          "checksum":"26ab04e1-b84e-8d78-f42d-881ee6fed0d5"
       },
       "genres":[
          {	
             "id":4,
             "name":"Fighting"
          }
       ],
       "involved_companies":[
          {
             "id":6116,
             "company":{
                "id":396,
                "name":"Dimps"
             }
          },
          {
             "id":6117,
             "company":{
                "id":1216,
                "name":"Pyramid"
             }
          },
          {
             "id":6118,
             "company":{
                "id":617,
                "name":"Bandai"
             }
          },
          {
             "id":6119,
             "company":{
                "id":82,
                "name":"Atari"
             }
          }
       ],
       "name":"Dragon Ball Z: Budokai",
       "rating":65.4589337838378,
       "release_dates":[
          {
             "id":5453,
             "y":2002
          },
          {
             "id":5454,
             "y":2003
          },
          {
             "id":138962,
             "y":2003
          },
          {
             "id":138963,
             "y":2003
          }
       ],
       "screenshots":[
          {
             "id":344553,
             "url":"//images.igdb.com/igdb/image/upload/t_thumb/sc7dux.jpg"
          },
          {
             "id":344554,
             "url":"//images.igdb.com/igdb/image/upload/t_thumb/sc7duy.jpg"
          },
          {
             "id":344555,
             "url":"//images.igdb.com/igdb/image/upload/t_thumb/sc7duz.jpg"
          },
          {
             "id":344556,
             "url":"//images.igdb.com/igdb/image/upload/t_thumb/sc7dv0.jpg"
          }
       ],
       "summary":"Join us on a wild ride through the best action cartoon series on TV, Dragonball Z. The story begins after Goku defeats Piccolo at the World Marital Arts Tournament and he comes to visit Master Roshi, when all of a sudden, his brother Raditz appears and kidnaps his son, Gohan, after he saves him he is sent to Other World to train with King Kai for for two more powerful Saiyan arriving one year later. This wild ride story takes you from the Saiyan to the Cell Games Saga.\n\nThere are also several options in the game: there is a world tournament mode where you could buy new moves and a practice mode where you can sharpen your skills before entering story mode. You could also summon Shenron when you collect all 7 Dragonballs. So, buckle up, hold on to your seat and enjoy the ride of Dragonball Z!"
    }
 
 
 */
