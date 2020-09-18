//alert('Hello')

// 1 Variable

//var name = 'Dima' //стараемся НЕ использовать var
//const lastName = 'Petov'
//let age = 27


// 8 Function

function calcAge(year) {
    return 2020 - year
}

function InfoAge(year){
    const age = calcAge(year)

    if (age > 0) {
        console.log(age)
    } else {
        console.log('Это будущее')
    }
}

InfoAge(1975)
InfoAge(2021)


//9 Array

const cars = ['Mazda', 'Volvo', 'KIA']
console.log(cars)
console.log(cars.length)

cars[0] = 'Porsche'
console.log(cars)


//10 Цикл

for (let i = 0; i < cars.length; i++) {
    const car = cars[i]
    console.log(car)
}

// новый вариант
for (let car of cars) {
    console.log(car)
}

//11 объекты
const person = {
    firstName: 'Dima',
    lastName: 'VVV',
    year: 1999,
    languages: ['Ru', 'En', 'De'],
    hasWife: true,
    greet: function () {
        console.log('greet from person')
    }
}

console.log(person.firstName)
console.log(person['lastName'])
const key = 'year'
console.log(person[key])
person.hasWife = false
person.isProgrammer = true

person.greet()
