/******w***********
    
    Project 3 Javascript
    Name: Yi Siang Chang
    Date: 2023-04-23
    Description: Project 3

******************/

const nameField = document.getElementById("name");
const phoneField = document.getElementById("phone");
const emailField = document.getElementById("email");
const form = document.getElementById("contact-form");

form.addEventListener("submit", function(event) {
    event.preventDefault();

    if (!nameField.value.trim()) {
        nameField.classList.add("error");
        document.getElementById("name-error").style.display = "block";
        nameField.focus();
        return;
    } else {
        nameField.classList.remove("error");
        document.getElementById("name-error").style.display = "none";
    }

    //const phoneRegex = /^\d{10}$/; Must match 10-digit phone number with no other characters or spaces. 
    
    //Phone format ###-###-####
    const phoneRegex = /^\d{3}-\d{3}-\d{4}$|^\d{10}$/;
    if (!phoneRegex.test(phoneField.value)) {
        phoneField.classList.add("error");
        document.getElementById("phone-error").style.display = "block";
        phoneField.focus();
        return;
    } else {
        phoneField.classList.remove("error");
        document.getElementById("phone-error").style.display = "none";
    }

    const emailRegex = /^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/;
    if (!emailRegex.test(emailField.value)) {
        emailField.classList.add("error");
        document.getElementById("email-error").style.display = "block";
        emailField.focus();
        //return; //Remove the "return" statement
    } else {
        emailField.classList.remove("error");
        document.getElementById("email-error").style.display = "none";
    }

    form.submit();
});