----------- ESTOQUE VENDAS 90 D -----------

SELECT 
    o.ean,
    o.descricao,
    o.pesado,
	REPLACE(CAST(p.precocompra AS VARCHAR),'.',',') AS precocompra,
    REPLACE(CAST(p.precovarejo AS VARCHAR),'.',',') AS precovarejo,
    se.descricao AS seção,
    REPLACE(CAST(SUM(c.quantidade) AS VARCHAR),'.',',') AS quantidade,
    REPLACE(CAST(SUM(c.totalliquido) AS VARCHAR),'.',',') AS faturamento,
    REPLACE(CAST(e.estoquefinal AS VARCHAR),'.',',') AS estoque,
    ISNULL(
        CONVERT(VARCHAR, uv.ultima_venda, 103),
        'Nunca Vendido'
    ) AS ultima_venda,
    CASE
        WHEN uv.ultima_venda IS NULL
        THEN 'Nunca Vendido'
        ELSE CAST(
            DATEDIFF(
                DAY,
                uv.ultima_venda,
                GETDATE()
            ) AS VARCHAR
        )
    END AS dias_sem_venda
FROM erp_produtos o

INNER JOIN erp_precos p
ON o.id = p.produto

INNER JOIN erp_produtos_estoque e
ON o.id = e.produto

INNER JOIN erp_subfamilias s
ON s.id = o.subfamilia

INNER JOIN erp_secoes se
ON se.id = s.secao

INNER JOIN pdv_cupom_produtos c
ON c.ean = o.ean

LEFT JOIN (
    SELECT
        ean,
        MAX(datacupom) AS ultima_venda
    FROM pdv_cupom_produtos
    WHERE cancelado = 0
    GROUP BY ean
) uv
ON uv.ean = o.ean

WHERE
p.filial = 1

AND c.datacupom <= '2026-05-14'

AND c.datacupom >= '2026-02-13'

AND c.cancelado = 0

GROUP BY

o.ean,
o.descricao,
o.pesado,
p.precocompra,
p.precovarejo,
se.descricao,
e.estoquefinal,
uv.ultima_venda

ORDER BY o.descricao asc


----------- ESTOQUE TODOS PRODUTOS -----------

SELECT 
    o.ean,
    o.descricao,
    o.pesado,

    REPLACE(CAST(p.precocompra AS VARCHAR),'.',',') AS precocompra,
    REPLACE(CAST(p.precovarejo AS VARCHAR),'.',',') AS precovarejo,

    se.descricao AS seção,

    REPLACE(
        CAST(
            ISNULL(SUM(c.quantidade),0)
        AS VARCHAR),
    '.',',') AS quantidade,

    REPLACE(
        CAST(
            ISNULL(SUM(c.totalliquido),0)
        AS VARCHAR),
    '.',',') AS faturamento,

    REPLACE(
        CAST(
            ISNULL(e.estoquefinal,0)
        AS VARCHAR),
    '.',',') AS estoque,

    ISNULL(
        CONVERT(
            VARCHAR,
            uv.ultima_venda,
            103
        ),
        'Nunca Vendido'
    ) AS ultima_venda,

    CASE

        WHEN uv.ultima_venda IS NULL
        THEN 'Nunca Vendido'

        ELSE CAST(
            DATEDIFF(
                DAY,
                uv.ultima_venda,
                GETDATE()
            ) AS VARCHAR
        )

    END AS dias_sem_venda

FROM erp_produtos o

INNER JOIN erp_precos p
ON p.produto = o.id

INNER JOIN erp_produtos_estoque e
ON e.produto = o.id

INNER JOIN erp_subfamilias s
ON s.id = o.subfamilia

INNER JOIN erp_secoes se
ON se.id = s.secao

LEFT JOIN pdv_cupom_produtos c
ON c.ean = o.ean
AND c.cancelado = 0

LEFT JOIN (

    SELECT
        ean,
        MAX(datacupom) ultima_venda

    FROM pdv_cupom_produtos

    WHERE cancelado = 0

    GROUP BY ean

) uv

ON uv.ean = o.ean

WHERE
p.filial = 1 and
o.ativo = 1
GROUP BY

o.ean,
o.descricao,
o.pesado,

p.precocompra,
p.precovarejo,

se.descricao,

e.estoquefinal,

uv.ultima_venda

ORDER BY

o.descricao asc

