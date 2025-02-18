// 随机封面
function randomCover() {
    var coverList = [
        '/img/cover/1.png',
        '/img/cover/2.jpeg',
        '/img/cover/3.png',
        '/img/cover/4.png',
        '/img/cover/5.jpg',
        '/img/cover/6.jpg',
        '/img/cover/7.jpg',
        '/img/cover/8.jpg',
        '/img/cover/9.jpg',
        '/img/cover/10.jpg',
        '/img/cover/12.jpg',
        '/img/cover/14.jpg',
        '/img/cover/15.jpg',
        '/img/cover/16.jpg',
        '/img/cover/17.jpg',
        '/img/cover/18.jpg',
        '/img/cover/19.jpg',
        '/img/cover/20.jpg',
        '/img/cover/21.jpg',
        '/img/cover/22.jpg'
    ];
    return coverList[Math.floor(Math.random() * coverList.length)];
} 