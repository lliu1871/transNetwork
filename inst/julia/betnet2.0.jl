using betnet
using ArgParse

function parse_commandline()
    s = ArgParseSettings(description = "Inference script for transNetworkInference using the betnet package.")

    @add_arg_table! s begin
        "--temp", "-t"
            help = "Path to the Temporal Data CSV file"
            arg_type = String
            default = "temporal.csv"
        "--snp", "-s"
            help = "Path to the SNP distance Data CSV file"
            arg_type = String
            default = "SNP.csv"
        "--contact", "-c"
            help = "Path to the Contact File CSV"
            arg_type = String
            default = ""
        "--genomeSize", "-g"
            help = "Size of the genome in base pairs"
            arg_type = Int
            default = 1000000
        "--itr", "-i"
            help = "Number of MCMC iterations to run"
            arg_type = Int
            default = 1000000
        "--burn", "-b"
            help = "Number of initial iterations to discard (burn-in)"
            arg_type = Int
            default = 0
        "--sub", "-n"
            help = "Subsampling interval (save every n-th iteration)"
            arg_type = Int
            default = 1000
        "--out", "-o"
            help = "Output filename for the parameter CSV"
            arg_type = String
            default = "betnet_output.csv"
    end

    return parse_args(s)
end

function main()
    args = parse_commandline()

    println("--- Configuration ---")
    for (arg, val) in args
        println("$arg: $val")
    end
    println("---------------------")

    # Running the inference with @time for performance benchmarking
    @time transNetworkInference(
        tempfile    = args["temp"],
        SNPfile     = args["snp"],
        Contactfile = args["contact"],
        genomeSize  = args["genomeSize"],
        itr_MCMC    = args["itr"],
        burn_in     = args["burn"],
        subsample   = args["sub"],
        outputfile  = args["out"]
    )

    println("\nSuccess: Results saved to ", args["out"])
end

main()
