const orderCtx =
        document.getElementById("weeklyOrderChart");

const orderLoading =
        document.querySelector(".order-chart-skeleton");

async function loadOrderChart() {

    try {

        const response = await fetch(
                contextPath +
                "/admin/dashboard/thong-ke-tuan?type=don_hang"
                );

        const text = await response.text();

        console.log(text);

        const data = JSON.parse(text);

        console.log(data);

        setTimeout(() => {

            orderLoading.classList.add("hide");

            new Chart(orderCtx, {

                type: 'bar',

                data: {

                    labels: data.map(i => i.weekName),

                    datasets: [{

                            label: 'Đơn Hàng',

                            data: data.map(i => i.value),

                            backgroundColor:
                                    'rgba(230,57,70,.85)',

                            hoverBackgroundColor:
                                    '#d62839',
                            


                            borderSkipped: false,

                            barThickness: 36
                        }]
                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    interaction: {
                        intersect: false,
                        mode: 'index'
                    },

                    animations: {

                        y: {

                            duration: 1800,

                            easing: 'easeOutQuart',

                            from: (ctx) => {

                                if (ctx.type === 'data') {

                                    return ctx.chart
                                            .scales.y
                                            .getPixelForValue(0);
                                }

                                return 0;
                            }
                        }
                    },

                    plugins: {

                        legend: {

                            labels: {

                                color: '#111',

                                font: {
                                    size: 13,
                                    weight: '600'
                                }
                            }
                        },

                        tooltip: {

                            backgroundColor: '#111',

                            titleColor: '#fff',

                            bodyColor: '#fff',

                            padding: 12,

                            cornerRadius: 10
                        }
                    },

                    scales: {

                        x: {

                            ticks: {
                                color: '#111'
                            },

                            grid: {
                                display: false
                            }
                        },

                        y: {

                            beginAtZero: true,

                            ticks: {
                                color: '#111'
                            },

                            grid: {
                                color: 'rgba(0,0,0,.06)'
                            }
                        }
                    }
                }
            });

        }, 800);

    } catch (error) {

        console.error(
                "Lỗi load order chart:",
                error
                );
    }
}

loadOrderChart();