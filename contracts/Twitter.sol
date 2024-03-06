// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
contract Twitter {
    
    uint16 public max_tweet_length = 320;

    // Tweet structure
    struct Tweet {
        uint256 ID;
        address author;
        string content;
        uint256 timestamp;
        uint64 likes;
    }

    mapping (address => Tweet[]) internal tweets;
    address internal _owner;

    // Gets called at time of deployment.
    constructor() {
        _owner = msg.sender;
    }

    // Define the EVENTs
    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address likedBy, address author, uint256 id, uint64 likes);
    event TweetUnLiked(address unLikedBy, address author, uint256 id, uint64 likes);

    modifier onlyOwner() {
        require(msg.sender == _owner, "You are not an OWNER!");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        max_tweet_length = newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        // Check for the tweet length.
        require(bytes(_tweet).length <= max_tweet_length, "Tweet is too long bro!");

        Tweet memory newTweet = Tweet ({
            ID: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
        emit TweetCreated(newTweet.ID, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].ID == id, "Tweet does not exist!");
        tweets[author][id].likes++;

        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].ID == id, "Tweet does not exist!");
        require(tweets[author][id].likes > 0, "Tweet has no likes.");
        tweets[author][id].likes--;

        emit TweetUnLiked(msg.sender, author, id, tweets[author][id].likes);

    }

    function getTweet(uint16 _i) public view returns (Tweet memory){
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address owner) public view returns (Tweet[] memory) {
        return tweets[owner];
    }
} 