SELECT 
    soh.OrderDate AS Data,
    soh.SalesOrderID AS IdPedido,
    sod.SpecialOfferID AS IdOferta,
    soh.CustomerID,
    soh.SalesPersonID AS IDvendedor,
	st.TerritoryID,
	pc.ProductCategoryID IdCategoria,
	psc.ProductSubcategoryID IdSubcategoria,
	p.ProductID IdProduto,
    CONCAT_WS(' ', pe.FirstName, pe.MiddleName, pe.LastName) AS NomeVendedor,
    s.Name AS Loja,
	st.[Name] Regional,
    st.[Group] AS Região,
    st.CountryRegionCode AS País,
    a.City AS Cidade,
    p.Name AS Produto,
    pc.Name AS Categoria,
    psc.Name AS SubCategoria,
    sod.OrderQty AS Quantidade,
    sod.UnitPrice AS PrecoUnitario,
    sod.OrderQty * sod.UnitPrice AS ValorSubtotal, 
    sod.UnitPriceDiscount AS Desconto,
    sod.LineTotal AS ValorTotal,

    -- Distribuição proporcional
    CAST(sod.LineTotal AS FLOAT) / NULLIF(soh.SubTotal, 0) * soh.TaxAmt AS ImpostosDistribuidos,
    CAST(sod.LineTotal AS FLOAT) / NULLIF(soh.SubTotal, 0) * soh.Freight AS FreteDistribuido,
    CAST(sod.LineTotal AS FLOAT) / NULLIF(soh.SubTotal, 0) * soh.TotalDue AS ReceitaTotalDistribuida,

    AVG(pch.StandardCost) AS CustoMedio
FROM Sales.SalesOrderHeader soh
LEFT JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
LEFT JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
LEFT JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
LEFT JOIN Person.BusinessEntityAddress bea ON s.BusinessEntityID = bea.BusinessEntityID
LEFT JOIN Person.Address a ON bea.AddressID = a.AddressID
LEFT JOIN Production.Product p ON sod.ProductID = p.ProductID
LEFT JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN Production.ProductCostHistory pch ON p.ProductID = pch.ProductID
LEFT JOIN Person.Person pe ON soh.SalesPersonID = pe.BusinessEntityID
GROUP BY 
    soh.OrderDate,
    soh.SalesOrderID,
    sod.SpecialOfferID,
    soh.CustomerID,
    soh.SalesPersonID,
	st.TerritoryID,
	pc.ProductCategoryID,
	psc.ProductSubcategoryID,
	p.ProductID,
    CONCAT_WS(' ', pe.FirstName, pe.MiddleName, pe.LastName),
    s.Name,
	st.[Name],
    st.[Group],
    st.CountryRegionCode,
    a.City,
    p.Name,
    pc.Name,
    psc.Name,
    sod.OrderQty,
    sod.UnitPrice,
    sod.UnitPriceDiscount,
    sod.LineTotal,
    soh.SubTotal,
    soh.TaxAmt,
    soh.Freight,
    soh.TotalDue
