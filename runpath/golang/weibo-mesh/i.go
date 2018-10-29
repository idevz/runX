package main

import (
	"flag"
	"fmt"
	"github.com/montanaflynn/stats"
	"github.com/smallnest/rpcx/log"
	"github.com/weibocom/motan-go"
	"sync"
	"sync/atomic"
	"time"
)

func getMClient() (mclient *motan.Client) {
	mccontext := motan.GetClientContext("/media/psf/runX/runpath/golang/weibo-mesh/mesh.yaml")
	mccontext.Start(nil)
	mclient = mccontext.GetClient("hello-world-direct")
	return
}

func doRCall(mclient *motan.Client) (reply string, err error) {
	args := make(map[string]string, 16)
	args["one"] = "yes"
	args["two"] = "no"
	err = mclient.Call("Hello", []interface{}{args}, &reply)
	if err != nil {
		fmt.Printf("motan call fail! err:%v\n", err)
	}
	return
}

var concurrency = flag.Int("x", 1, "concurrency")
var total = flag.Int("n", 1, "total requests for all clients")

func main() {
	flag.Parse()
	n := *concurrency
	m := *total / n

	var wg sync.WaitGroup
	wg.Add(n * m)

	var trans uint64
	var transOK uint64
	d := make([][]int64, 0, n)

	totalT := time.Now().UnixNano()
	for i := 0; i < n; i++ {
		dt := make([]int64, 0, m)
		d = append(d, dt)
		go func(i int) {
			mclient := getMClient()
			for j := 0; j < 5; j++ {
				doRCall(mclient)
			}
			for j := 0; j < m; j++ {
				t := time.Now().UnixNano()
				reply, err := doRCall(mclient)
				t = time.Now().UnixNano() - t
				d[i] = append(d[i], t)

				if err == nil && reply != "" {
					atomic.AddUint64(&transOK, 1)
				}
				atomic.AddUint64(&trans, 1)
				wg.Done()
			}
		}(i)
	}
	wg.Wait()
	totalT = time.Now().UnixNano() - totalT
	totalT = totalT / 1000000
	log.Infof("took %d ms for %d requests\n", totalT, n*m)

	totalD := make([]int64, 0, n*m)
	for _, k := range d {
		totalD = append(totalD, k...)
	}
	totalD2 := make([]float64, 0, n*m)
	for _, k := range totalD {
		totalD2 = append(totalD2, float64(k))
	}

	mean, _ := stats.Mean(totalD2)
	median, _ := stats.Median(totalD2)
	max, _ := stats.Max(totalD2)
	min, _ := stats.Min(totalD2)
	p99, _ := stats.Percentile(totalD2, 99.9)

	log.Infof("sent     requests    : %d\n", n*m)
	log.Infof("received requests    : %d\n", atomic.LoadUint64(&trans))
	log.Infof("received requests_OK : %d\n", atomic.LoadUint64(&transOK))
	log.Infof("throughput  (TPS)    : %d\n", int64(n*m)*1000/totalT)
	log.Infof("mean: %.f ns, median: %.f ns, max: %.f ns, min: %.f ns, p99: %.f ns\n", mean, median, max, min, p99)
	log.Infof("mean: %d ms, median: %d ms, max: %d ms, min: %d ms, p99: %d ms\n", int64(mean/1000000), int64(median/1000000), int64(max/1000000), int64(min/1000000), int64(p99/1000000))

}
