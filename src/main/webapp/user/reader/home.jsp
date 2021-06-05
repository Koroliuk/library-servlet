<%@ page import="ua.training.model.entity.Book" %>
<%@ page import="ua.training.model.entity.Author" %>
<%@ page import="ua.training.model.entity.Order" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.Period" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="language"
       value="${not empty param.language ? param.language : not empty language ? language : pageContext.request.locale}"
       scope="session"/>
<fmt:setLocale value="${language}"/>
<fmt:setBundle basename="messages"/>
<!DOCTYPE html>
<html lang="${language}">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>User home page</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
            integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
            integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
            integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
            crossorigin="anonymous"></script>
</head>
<header class="d-flex align-items-center justify-content-center justify-content-md-between py-3 mb-4 border-bottom">
    <span class="d-flex align-items-center col-md-3 mb-2 mb-md-0 text-dark text-decoration-none h3"><fmt:message
            key="header.library.name"/></span>
    <div class="d-flex flex-row mr-3">
        <form class="mr-2">
            <select class="custom-select" id="language" name="language" onchange="submit()">
                <option value="en" ${language == 'en' ? 'selected' : ''}><fmt:message
                        key="header.language.english"/></option>
                <option value="ua" ${language == 'ua' ? 'selected' : ''}><fmt:message
                        key="header.language.ukrainian"/></option>
            </select>
        </form>
        <a class="btn btn-dark" href="${pageContext.request.contextPath}/app/logout"><fmt:message key="header.logout"/></a>
    </div>
</header>
<body>
    <div class="container text-center">
        <h3>Кабінет користувача: <%= session.getAttribute("userLogin") %></h3>
        <div>
            <form method="post" action="${pageContext.request.contextPath}/app/search?page=1">
                <label>
                    <input class="form-control me-2 mr-2" type="text" name="keyWords" placeholder="Пошук">
                </label>
                <input class="btn btn-outline-success p-1" type="submit" value="Знайти">
            </form>
        </div>
        <c:if test="${param.successOrder == true}">
            <span class="text-success">Книгу замовлено успішно</span>
        </c:if>
        <br/>
        <h3>Абонемент</h3>
        <div class="row justify-content-center">
            <div class="col-auto">
                <table class="table table-responsive">
                    <th>Id</th>
                    <th>Book</th>
                    <th>Authors</th>
                    <th>Status</th>
                    <th>End date/Fine</th>
                    <c:forEach items="${requestScope.orderList}" var="order">
                        <tr>
                            <td>${order.id}</td>
                            <td>${order.book.title}</td>
                            <td>
                                <%
                                    Order order = (Order) pageContext.getAttribute("order");
                                    ;
                                    Book book = order.getBook();
                                    String authors = "";
                                    StringBuilder authorsString = new StringBuilder();
                                    for (Author author : book.getAuthors()) {
                                        authorsString.append(author.getName()).append(",").append(" ");
                                    }
                                    authorsString.deleteCharAt(authorsString.length() - 1);
                                    authorsString.deleteCharAt(authorsString.length() - 1);
                                    authors = authorsString.toString();
                                    request.setAttribute("authorsString", authors);
                                %>
                                    ${requestScope.authorsString}
                            </td>
                            <td>${order.orderStatus}</td>
                            <%
                                LocalDate now = LocalDate.now();
                                LocalDate end = order.getEndDate();
                                boolean flag = now.isAfter(end);
                                request.setAttribute("flag", flag);
                            %>
                            <c:if test="${requestScope.flag == true}">
                                <%
                                    int amountOfDays = Period.between(end, now).getDays();
                                    float fine = (float) (amountOfDays * book.getPrice() * 0.01);
                                    request.setAttribute("fine", fine);
                                %>
                                <td>
                                    <a href="${pageContext.request.contextPath}/app/reader/payFine?orderId=${order.id}">${fine}</a>
                                </td>
                            </c:if>
                            <c:if test="${requestScope.flag == false}">
                                <td>${order.endDate}</td>
                            </c:if>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
    </div>
</body>
<footer class="navbar fixed-bottom d-flex flex-row justify-content-sm-between align-items-center bg-light text-lg-start p-3">
    <div>
        <p>
            <fmt:message key="footer.licence"/>
            <a href="https://github.com/Koroliuk/Library_servlet/blob/main/LICENSE">
                GNU GPLv3 License
            </a>.
            <br>
            <a href="https://github.com/Koroliuk/Library_servlet"><fmt:message key="footer.project.github"/></a><br/>
            <span>@2021</span>
        </p>
    </div>
    <div>
        <p>
            <fmt:message key="footer.questions"/>
            <a href="https://github.com/Koroliuk/Library_servlet/issues/new">GitHub</a>.
        </p>
    </div>
</footer>
</html>